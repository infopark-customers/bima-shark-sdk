require "webmock/rspec"

module Shark
  module RSpec
    module FakeDoubleOptInService
      class Request
        include Singleton

        def self.setup
          instance = self.instance
          instance.stub_requests
        end

        def stub_requests
          WebMock.stub_request(:post, %r|^#{host}/requests|).to_return do |request|
            log_info "Faking POST request with body: #{request.body}"

            data = JSON.parse(request.body)["data"]
            attributes = data["attributes"] || {}

            ObjectCache.instance.create_request(attributes)

            fake_response(200, {
              data: {
                id: SecureRandom.uuid,
                attributes: attributes,
                type: "requests"
              }
            })
          end

          WebMock.stub_request(:post, %r|^#{host}/executions/.+/verify|).to_return do |request|
            log_info "Faking POST request"

            headers = { content_type: "application/vnd.api+json" }

            verification_token = request.uri.path.split("/").reverse[1]
            object = ObjectCache.instance.find_execution(verification_token)

            if verification_token_invalid?(object)
              fake_response(404, { errors: [] })
            else
              attributes = object["attributes"]
              is_verification_time_expired = Time.now.to_i > attributes["verification_expires_at"]
              is_number_of_verification_requests_exceeded = attributes["max_verifications"] <= attributes["verifications_count"]

              if is_verification_time_expired
                fake_response(422, { errors: [{ code: "verification_expired" }] })
              elsif is_number_of_verification_requests_exceeded
                fake_response(422, { errors: [{ code: "exceeded_number_of_verification_requests" }] })
              else
                fake_response(200, { data: object })
              end
            end
          end

          WebMock.stub_request(:get, %r|^#{host}/executions/.+|).to_return do |request|
            log_info "Faking GET request"

            headers = { content_type: "application/vnd.api+json" }

            verification_token = request.uri.path.split("/").reverse[0]
            object = ObjectCache.instance.find_execution(verification_token)

            if verification_token_invalid?(object)
              fake_response(404, { errors: [] })
            else
              attributes = object["attributes"]

              if attributes["verifications_count"] === 0
                fake_response(422, { errors: [{ code: "requested_unverified_execution" }] })
              else
                fake_response(200, { data: object })
              end
            end
          end

          WebMock.stub_request(:delete, %r|^#{host}/executions/.+|).to_return do |request|
            log_info "Faking DELETE request"

            headers = { content_type: "application/vnd.api+json" }

            verification_token = request.uri.path.split("/").reverse[0]
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

          attributes = object["attributes"]
          is_execution_time_expired = Time.now.to_i > attributes["execution_expires_at"]
          is_verification_time_expired = Time.now.to_i > attributes["verification_expires_at"]
          has_verification_been_verified = attributes["verifications_count"] > 0

          return true  if is_execution_time_expired
          return true  if is_verification_time_expired && !has_verification_been_verified

          false
        end

        def fake_response(status, body)
          {
            headers: {
              content_type: "application/vnd.api+json"
            },
            status: status,
            body: body.is_a?(String) ? body : body.to_json
          }
        end

        def host
          Shark.configuration.double_opt_in_service.site
        end

        def log_info(message)
          Shark.logger.info "[Shark][DoubleOptInService] #{message}"
        end
      end
    end
  end
end
