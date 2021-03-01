# frozen_string_literal: true

require 'webmock/rspec'

module Shark
  module RSpec
    module FakeDoubleOptIn
      class Request
        include Singleton

        def self.setup
          instance = self.instance
          instance.stub_requests
        end

        def stub_requests
          WebMock.stub_request(:post, %r{^#{host}/requests}).to_return do |request|
            log_info "Faking POST request with body: #{request.body}"

            data = JSON.parse(request.body)['data']
            attributes = data['attributes'] || {}

            ObjectCache.instance.create_request(attributes)

            fake_response(200, {
                            data: {
                              id: SecureRandom.uuid,
                              attributes: attributes,
                              type: 'requests'
                            }
                          })
          end

          WebMock.stub_request(:post, %r{^#{host}/executions/.+/verify}).to_return do |request|
            log_info 'Faking POST request'

            verification_token = request.uri.path.split('/').reverse[1]
            object = ObjectCache.instance.find_execution(verification_token)

            if verification_token_invalid?(object)
              fake_response(404, { errors: [] })
            else
              verification_expires_at = object['attributes']['verification_expires_at']
              max_verifications = object['attributes']['max_verifications']
              verifications_count = object['attributes']['verifications_count']

              is_verification_expired = Time.now.to_i > verification_expires_at
              is_number_of_requests_exceeded = max_verifications <= verifications_count

              if is_verification_expired
                errors = [{ code: 'verification_expired' }]
                fake_response(422, { errors: errors })
              elsif is_number_of_requests_exceeded
                errors = [{ code: 'exceeded_number_of_verification_requests' }]
                fake_response(422, { errors: errors })
              else
                fake_response(200, { data: object })
              end
            end
          end

          WebMock.stub_request(:get, %r{^#{host}/executions/.+}).to_return do |request|
            log_info 'Faking GET request'

            verification_token = request.uri.path.split('/').reverse[0]
            object = ObjectCache.instance.find_execution(verification_token)

            if verification_token_invalid?(object)
              fake_response(404, { errors: [] })
            else
              attributes = object['attributes']

              if attributes['verifications_count'].zero?
                fake_response(422, { errors: [{ code: 'requested_unverified_execution' }] })
              else
                fake_response(200, { data: object })
              end
            end
          end

          WebMock.stub_request(:delete, %r{^#{host}/executions/.+}).to_return do |request|
            log_info 'Faking DELETE request'

            verification_token = request.uri.path.split('/').reverse[0]
            object = ObjectCache.instance.find_execution(verification_token)

            if verification_token_invalid?(object)
              fake_response(404, { errors: [] })
            else
              ObjectCache.instance.remove_execution(verification_token)
              fake_response(200, { data: object })
            end
          end
        end

        def verification_token_invalid?(object)
          return true  if object.blank?

          execution_expires_at = object['attributes']['execution_expires_at']
          verification_expires_at = object['attributes']['verification_expires_at']
          verifications_count = object['attributes']['verifications_count']

          is_execution_time_expired = Time.now.to_i > execution_expires_at
          is_verification_expired = Time.now.to_i > verification_expires_at
          has_verification_been_verified = verifications_count.positive?

          return true  if is_execution_time_expired
          return true  if is_verification_expired && !has_verification_been_verified

          false
        end

        def fake_response(status, body)
          {
            headers: {
              content_type: 'application/vnd.api+json'
            },
            status: status,
            body: body.is_a?(String) ? body : body.to_json
          }
        end

        def host
          Shark.configuration.double_opt_in.site
        end

        def log_info(message)
          Shark.logger.info "[Shark][DoubleOptInService] #{message}"
        end
      end
    end
  end
end
