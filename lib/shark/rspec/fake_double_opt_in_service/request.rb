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
            log_info "[Shark][DoubleOptInService] Faking POST request with body: #{request.body}"

            payload_data = JSON.parse(request.body)["data"]
            id = payload_data["attributes"]["legal_subject_id"]

            object_data = ObjectCache.instance.add(payload_data)

            {
              headers: { content_type: "application/vnd.api+json" },
              status: 200,
              body: {
                data: object_data
              }.to_json
            }
          end

          # WebMock.stub_request(:get, %r|^#{host}/consents/.+|).to_return do |request|
          #   log_info "[Shark][ConsentService] Faking GET request"
          #
          #   id = request.uri.path.split("/")[2]
          #
          #   object_data = ObjectCache.instance.objects.detect do |object|
          #     object["id"] == id
          #   end
          #
          #   if object_data.present?
          #     {
          #       headers: { content_type: "application/vnd.api+json" },
          #       body: { data: object_data }.to_json,
          #       status: 200
          #     }
          #   else
          #     {
          #       headers: { content_type: "application/vnd.api+json" },
          #       body: { errors: [] }.to_json,
          #       status: 404
          #     }
          #   end
          # end
        end

        def host
          Shark.configuration.double_opt_in_service.site
        end

        def log_info(message)
          Shark.logger.info message
        end
      end
    end
  end
end
