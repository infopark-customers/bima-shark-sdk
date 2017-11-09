require "webmock/rspec"

module FakeContactService
  class Request
    include Singleton

    def self.setup
      instance = self.instance
      instance.stub_requests
    end

    def stub_requests
      host = self.class.host

      WebMock.stub_request(:post, %r|^#{host}.*|).to_return do |request|
        # TODO
        # Rails.logger.info "[Shark][ContactService] Faking POST request with body: #{request.body}"

        id = rand(10 ** 4)
        type = request.uri.path.split("/")[2]
        parsed_data = JSON.parse(request.body)["data"]
        parsed_data["id"] = id

        # TODO replace?
        FakeContactService::ObjectCache.instance.add(parsed_data)

        {
          headers: { content_type: "application/vnd.api+json" },
          status: 201,
          body: { data: parsed_data }.to_json
        }
      end

      WebMock.stub_request(:get, %r|^#{host}.*$|).to_return do |request|
        # TODO
        # Rails.logger.info "[Shark][ContactService] Faking GET request"

        type = request.uri.path.split("/")[2]

        objects = FakeContactService::ObjectCache.instance.objects.select do |object|
          object["type"] == type
        end

        {
          headers: { content_type: "application/vnd.api+json" },
          body: { data: objects }.to_json
        }
      end

      WebMock.stub_request(:get, %r|^#{host}.*/.+|).to_return do |request|
        # TODO
        # Rails.logger.info "[Shark][ContactService] Faking GET request with ID"

        type = request.uri.path.split("/")[2]
        id = request.uri.path.split("/")[3]

        object = FakeContactService::ObjectCache.instance.objects.detect do |object|
          object["id"].to_s == id && object["type"] == type
        end

        {
          headers: { content_type: "application/vnd.api+json" },
          body: { data: object }.to_json
        }
      end

      WebMock.stub_request(:patch, %r|^#{host}.*/.+|).to_return do |request|
        # TODO
        # Rails.logger.info "[Shark][ContactService] Faking PATCH request with body: #{request.body}"

        type = request.uri.path.split("/")[2]
        id = request.uri.path.split("/")[3]
        parsed_data = JSON.parse(request.body)["data"]

        object = FakeContactService::ObjectCache.instance.objects.detect do |object|
          object["id"].to_s == id && object["type"] == type
        end

        (parsed_data["attributes"] || {}).each do |key, value|
          object["attributes"][key] = value
        end

        # TODO relationships...

        {
          headers: { content_type: "application/vnd.api+json" },
          body: { data: object }.to_json
        }
      end

      WebMock.stub_request(:delete, %r|^#{host}.*/.+|).to_return do |request|
        # TODO
        # Rails.logger.info "[Shark][ContactService] Faking DELETE request"

        type = request.uri.path.split("/")[2]
        id = request.uri.path.split("/")[3]

        object = FakeContactService::ObjectCache.instance.objects.detect do |object|
          object["id"].to_s == id && object["type"] == type
        end

        FakeContactService::ObjectCache.instance.objects.delete(object)

        {
          headers: { content_type: "application/vnd.api+json" },
          status: 204,
          body: {}.to_json
        }
      end
    end

    def self.host
      Shark.configuration.contact_service.site
    end
  end
end
