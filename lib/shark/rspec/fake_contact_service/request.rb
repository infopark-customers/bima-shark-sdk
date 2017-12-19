require "webmock/rspec"

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
          WebMock.stub_request(:post, %r|^#{host}.*|).to_return do |request|
            log_info "[Shark][ContactService] Faking POST request with body: #{request.body}"

            id = rand(10 ** 4)
            type = request.uri.path.split("/")[2]
            parsed_data = JSON.parse(request.body)["data"]
            parsed_data["id"] = id

            FakeContactService::ObjectCache.instance.add(parsed_data)

            {
              headers: { content_type: "application/vnd.api+json" },
              status: 201,
              body: { data: parsed_data }.to_json
            }
          end

          WebMock.stub_request(:get, %r|^#{host}.*$|).to_return do |request|
            log_info "[Shark][ContactService] Faking GET request"

            type = request.uri.path.split("/")[2]
            params = query_params_to_object(request.uri)
            objects = []

            objects = if %w(contacts accounts).include?(type) && params["filter"].present?
                        FakeContactService::ObjectCache.instance.search_objects(type, params)
                      elsif %w(activities).include?(type) && params["filter"].present?
                        FakeContactService::ObjectCache.instance.objects_contain(type, params)
                      else
                        FakeContactService::ObjectCache.instance.objects.select do |object|
                          object["type"] == type
                        end
                      end

            {
              headers: { content_type: "application/vnd.api+json" },
              body: { data: objects }.to_json,
              status: 200
            }
          end

          WebMock.stub_request(:get, %r|^#{host}.*/.+|).to_return do |request|
            log_info "[Shark][ContactService] Faking GET request with ID"

            type = request.uri.path.split("/")[2]
            id = request.uri.path.split("/")[3]

            object = FakeContactService::ObjectCache.instance.objects.detect do |object|
              object["id"].to_s == id && object["type"] == type
            end

            if object.present?
              {
                headers: { content_type: "application/vnd.api+json" },
                body: { data: object }.to_json,
                status: 200
              }
            else
              {
                headers: { content_type: "application/vnd.api+json" },
                body: { errors: [] }.to_json,
                status: 404
              }
            end
          end

          WebMock.stub_request(:patch, %r|^#{host}.*/.+|).to_return do |request|
            log_info "[Shark][ContactService] Faking PATCH request with body: #{request.body}"

            type = request.uri.path.split("/")[2]
            id = request.uri.path.split("/")[3]
            parsed_data = JSON.parse(request.body)["data"]

            object = FakeContactService::ObjectCache.instance.objects.detect do |object|
              object["id"].to_s == id && object["type"] == type
            end

            if object.present?
              (parsed_data["attributes"] || {}).each do |key, value|
                object["attributes"] = {}  if object["attributes"].blank?
                object["attributes"][key] = value
              end

              (parsed_data["relationships"] || {}).each do |key, value|
                object["relationships"] = {}  if object["relationships"].blank?
                object["relationships"][key] = value
              end

              {
                headers: { content_type: "application/vnd.api+json" },
                status: 200,
                body: { data: object }.to_json
              }
            else
              {
                headers: { content_type: "application/vnd.api+json" },
                status: 404,
                body: { errors: [] }.to_json
              }
            end
          end

          WebMock.stub_request(:delete, %r|^#{host}.*/.+|).to_return do |request|
            log_info "[Shark][ContactService] Faking DELETE request"

            type = request.uri.path.split("/")[2]
            id = request.uri.path.split("/")[3]

            object = FakeContactService::ObjectCache.instance.objects.detect do |object|
              object["id"].to_s == id && object["type"] == type
            end

            if object.present?
              FakeContactService::ObjectCache.instance.objects.delete(object)

              {
                headers: { content_type: "application/vnd.api+json" },
                status: 204,
                body: {}.to_json
              }
            else
              {
                headers: { content_type: "application/vnd.api+json" },
                status: 404,
                body: { errors: [] }.to_json
              }
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
          uri = URI::parse(request_uri)
          Rack::Utils.parse_nested_query(uri.query)
        end
      end
    end
  end
end
