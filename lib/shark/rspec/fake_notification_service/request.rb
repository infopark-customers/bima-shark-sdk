require "webmock/rspec"

module Shark
  module RSpec
    module FakeNotificationService
      class Request
        include Singleton

        def self.setup
          instance = self.instance
          instance.stub_requests
        end

        def stub_requests
          WebMock.stub_request(:post, %r|^#{host}/notifications/bulk_creation|).to_return do |request|
            log_info "[Shark][NotificationService] Faking POST bulk creation request with body: #{request.body}"

            {
              headers: { content_type: "application/vnd.api+json" },
              status: 201,
              body: {
                data: {
                  type: "notifications",
                  id: "12345678-1234-1234-1234-1234567890ab"
                }
              }.to_json
            }
          end

          WebMock.stub_request(:post, %r|^#{host}/notifications|).to_return do |request|
            log_info "[Shark][NotificationService] Faking POST request with body: #{request.body}"

            id = SecureRandom.hex
            payload_data = JSON.parse(request.body)["data"]

            {
              headers: { content_type: "application/vnd.api+json" },
              status: 201,
              body: {
                data: {
                  type: "notifications",
                  id: id,
                  attributes: payload_data
                }
              }.to_json
            }
          end

        end

        def host
          Shark.configuration.notification_service.site
        end

        def log_info(message)
          Shark.logger.info message
        end
      end
    end
  end
end
