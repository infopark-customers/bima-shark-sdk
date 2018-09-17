require "webmock/rspec"

module Shark
  module RSpec
    module FakeSubscriptionService
      class Request
        include Singleton

        def self.setup
          instance = self.instance
          instance.stub_requests
        end

        def stub_requests
          WebMock.stub_request(:post, %r|^#{host}/subscriptions|).to_return do |request|
            log_info "[Shark][SubscriptionService] Faking POST request with body: #{request.body}"

            payload_data = JSON.parse(request.body)["data"]["attributes"]

            object_data = ObjectCache.instance.add(payload_data)

            {
              headers: { content_type: "application/vnd.api+json" },
              status: 201,
              body: {
                data: object_data
              }.to_json
            }
          end

          WebMock.stub_request(:post, %r|^#{host}/subscriptions/bulk_creation|).to_return do |request|
            log_info "[Shark][SubscriptionService] Faking POST request with body: #{request.body}"

            payload_data = JSON.parse(request.body)["data"]["attributes"]["subscriptions"]

            objects_data = ObjectCache.instance.add_multiple(payload_data)

            {
              headers: { content_type: "application/vnd.api+json" },
              status: 201,
              body: {
                data: objects_data
              }.to_json
            }
          end

          WebMock.stub_request(:get, %r|^#{host}/subscriptions|).to_return do |request|
            log_info "[Shark][SubscriptionService] Faking GET request"

            objects_data = ObjectCache.instance.objects

            {
              headers: { content_type: "application/vnd.api+json" },
              body: { data: objects_data }.to_json,
              status: 200
            }
          end
        end

        def host
          Shark.configuration.subscription_service.site
        end

        def log_info(message)
          Shark.logger.info message
        end
      end
    end
  end
end