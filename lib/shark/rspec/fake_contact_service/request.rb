# frozen_string_literal: true

require 'webmock/rspec'

module Shark
  module RSpec
    module FakeContactService
      class Request
        include Singleton

        def self.setup
          instance = self.instance
          instance.stub_requests
        end

        def stub_requests
          cache = FakeContactService::ObjectCache.instance

          WebMock.stub_request(:post, %r{^#{host}/api/.*}).to_return do |request|
            log_info "[Shark][ContactService] Faking POST request with body: #{request.body}"

            id = SecureRandom.uuid
            parsed_data = JSON.parse(request.body)['data']
            parsed_data['id'] = id

            cache.add(parsed_data)
            SharkSpec.fake_response(201, data: parsed_data)
          end

          WebMock.stub_request(:get, %r{^#{host}/api/.*$}).to_return do |request|
            log_info '[Shark][ContactService] Faking GET request'

            type = request.uri.path.split('/')[2]
            params = query_params_to_object(request.uri)

            objects = if %w[contacts accounts].include?(type) && params['filter'].present?
                        cache.search_objects(type, params)
                      elsif %w[activities].include?(type) && params['filter'].present?
                        cache.objects_contain(type, params)
                      else
                        cache.objects.select do |object|
                          object['type'] == type
                        end
                      end

            SharkSpec.fake_response(200, data: objects)
          end

          WebMock.stub_request(:get, %r{^#{host}/api/.*/.+}).to_return do |request|
            log_info '[Shark][ContactService] Faking GET request with ID'

            type = request.uri.path.split('/')[2]
            id = request.uri.path.split('/')[3]
            query = request.uri.query_values

            object = cache.find(type, id)

            if object.present?
              body = { data: object }

              if query && query['include']
                relation_name = query['include']
                included_objects = cache.included_resources(object, query)

                if included_objects.empty?
                  object['relationships'] ||= { relation_name => { data: [] } }
                end
                body = {
                  data: object,
                  included: included_objects
                }
              end

              SharkSpec.fake_response(200, body)
            else
              SharkSpec.fake_response(404, errors: [])
            end
          end

          WebMock.stub_request(:patch, %r{^#{host}/api/.*/.+}).to_return do |request|
            log_info "[Shark][ContactService] Faking PATCH request with body: #{request.body}"

            type = request.uri.path.split('/')[2]
            id = request.uri.path.split('/')[3]
            parsed_data = JSON.parse(request.body)['data']

            object = cache.find(type, id)

            if object.present?
              (parsed_data['attributes'] || {}).each do |key, value|
                object['attributes'] = {} if object['attributes'].blank?
                object['attributes'][key] = value
              end

              (parsed_data['relationships'] || {}).each do |key, value|
                object['relationships'] = {} if object['relationships'].blank?
                object['relationships'][key] = value
              end

              SharkSpec.fake_response(200, data: object)
            else
              SharkSpec.fake_response(404, errors: [])
            end
          end

          WebMock.stub_request(:delete, %r{^#{host}/api/.*/.+}).to_return do |request|
            log_info '[Shark][ContactService] Faking DELETE request'

            type = request.uri.path.split('/')[2]
            id = request.uri.path.split('/')[3]

            object = cache.find(type, id)

            if object.present?
              cache.objects.delete(object)

              SharkSpec.fake_response(204, nil)
            else
              SharkSpec.fake_response(404, errors: [])
            end
          end
        end

        def host
          Shark.configuration.contact_service.site
        end

        def log_info(message)
          Shark.logger.info message
        end

        def query_params_to_object(request_uri)
          uri = URI.parse(request_uri)
          return {} if uri.query.blank?

          query = uri.query.gsub(/%5B[0-9]%5D/, '%5B%5D')
          Rack::Utils.parse_nested_query(query)
        end
      end
    end
  end
end
