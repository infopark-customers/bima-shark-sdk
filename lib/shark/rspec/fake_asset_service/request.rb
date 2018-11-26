require "webmock/rspec"

module Shark
  module RSpec
    module FakeAssetService
      class Request
        include Singleton

        def self.setup
          instance = self.instance
          instance.stub_requests
        end

        def host
          Shark.configuration.asset_service.site
        end

        def stub_requests
          WebMock.stub_request(:get, %r|^#{host}/assets/.+|).to_return do |request|
            log_info "[Shark][AssetService] Faking GET request"

            id = request.uri.path.split("/")[2]

            object_data = ObjectCache.instance.find(id)

            if object_data.present?
              {
                headers: { content_type: "application/vnd.api+json" },
                body: {
                  data: object_data
                }.to_json,
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

          WebMock.stub_request(:get, %r|^#{host}/assets|).to_return do |request|
            log_info "[Shark][AssetService] Faking GET request"

            {
              headers: { content_type: "application/vnd.api+json" },
              status: 200,
              body: {
                data: ObjectCache.instance.objects
              }.to_json
            }
          end

          WebMock.stub_request(:delete, %r|^#{host}/assets/.+|).to_return do |request|
            log_info "[Shark][AssetService] Faking DELETE request"

            id = request.uri.path.split("/")[2]

            ObjectCache.instance.remove(id)

            {
              headers: { content_type: "application/vnd.api+json" },
              body: nil,
              status: 204
            }

          end

          WebMock.stub_request(:post, %r|^#{host}/assets|).to_return do |request|
            log_info "[Shark][AssetService] Faking POST request with body: #{request.body}"

            payload = get_payload(request.body)
            object_data = ObjectCache.instance.add(payload)

            {
              headers: { content_type: "application/vnd.api+json" },
              status: 200,
              body: {
                data: object_data
              }.to_json
            }
          end
        end

        def log_info(message)
          Shark.logger.info message
        end

        private

        def get_payload(body)
          payload = JSON.parse(body)["data"]
          payload["attributes"]["id"] = payload["id"] if payload["id"]
          payload["attributes"]
        end
      end
    end
  end
end