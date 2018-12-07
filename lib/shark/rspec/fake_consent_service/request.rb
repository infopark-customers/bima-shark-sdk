require "webmock/rspec"

module Shark
  module RSpec
    module FakeConsentService
      class Request
        include Singleton

        def self.setup
          instance = self.instance
          instance.stub_requests
        end

        def stub_requests
          WebMock.stub_request(:post, %r|^#{host}/consents|).to_return do |request|
            log_info "[Shark][ConsentService] Faking POST request with body: #{request.body}"

            payload_data = JSON.parse(request.body)["data"]
            id = payload_data["attributes"]["legal_subject_id"]

            object_data = ObjectCache.instance.add(payload_data)
            SharkSpec.fake_response(200, data: object_data)
          end

          WebMock.stub_request(:get, %r|^#{host}/consents/.+|).to_return do |request|
            log_info "[Shark][ConsentService] Faking GET request"

            id = request.uri.path.split("/")[2]

            object_data = ObjectCache.instance.objects.detect do |object|
              object["id"] == id
            end

            if object_data.present?
              SharkSpec.fake_response(200, data: object_data)
            else
              SharkSpec.fake_response(404, errors: [])
            end
          end
        end

        def host
          Shark.configuration.consent_service.site
        end

        def log_info(message)
          Shark.logger.info message
        end
      end
    end
  end
end
