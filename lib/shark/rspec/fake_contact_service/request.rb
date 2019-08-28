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
          WebMock.stub_request(:post, %r|^#{host}/api/.*|).to_return do |request|
            log_info "[Shark][ContactService] Faking POST request with body: #{request.body}"

            id = SecureRandom.uuid
            type = request.uri.path.split("/")[2]
            parsed_data = JSON.parse(request.body)["data"]
            parsed_data["id"] = id

            FakeContactService::ObjectCache.instance.add(parsed_data)
            SharkSpec.fake_response(201, data: parsed_data)
          end

          WebMock.stub_request(:get, %r|^#{host}/api/.*$|).to_return do |request|
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

            SharkSpec.fake_response(200, data: objects)
          end

          WebMock.stub_request(:get, %r|^#{host}/api/.*/.+|).to_return do |request|
            log_info "[Shark][ContactService] Faking GET request with ID"

            type = request.uri.path.split("/")[2]
            id = request.uri.path.split("/")[3]
            query = request.uri.query_values

            object = FakeContactService::ObjectCache.instance.objects.detect do |object|
              object["id"].to_s == id && object["type"] == type
            end

            if object.present?
              body = { data: object }

              if query && query["include"]
                relation_name = query["include"]

                included_objects = FakeContactService::ObjectCache.instance.objects.select do |related_obj|
                  related_obj["type"] == relation_name &&
                  object["relationships"] &&
                  object["relationships"][relation_name] &&
                  object["relationships"][relation_name]["data"].map{|c| c["id"].to_s}.include?(related_obj["id"].to_s)
                end

                object["relationships"] ||= { relation_name => { data: [] } }  if included_objects.empty?
                body = { data: object, included: included_objects } #  if included_objects.present?
              end

              SharkSpec.fake_response(200, body)
            else
              SharkSpec.fake_response(404, errors: [])
            end
          end

          WebMock.stub_request(:patch, %r|^#{host}/api/.*/.+|).to_return do |request|
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

              SharkSpec.fake_response(200, data: object)
            else
              SharkSpec.fake_response(404, errors: [])
            end
          end

          WebMock.stub_request(:delete, %r|^#{host}/api/.*/.+|).to_return do |request|
            log_info "[Shark][ContactService] Faking DELETE request"

            type = request.uri.path.split("/")[2]
            id = request.uri.path.split("/")[3]

            object = FakeContactService::ObjectCache.instance.objects.detect do |object|
              object["id"].to_s == id && object["type"] == type
            end

            if object.present?
              FakeContactService::ObjectCache.instance.objects.delete(object)

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
          uri = URI::parse(request_uri)
          Rack::Utils.parse_nested_query(uri.query)
        end
      end
    end
  end
end
