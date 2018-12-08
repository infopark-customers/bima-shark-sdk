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

            object_data = ObjectCache.instance.add(payload_data)

            {
              headers: { content_type: "application/vnd.api+json" },
              status: 200,
              body: {
                data: object_data
              }.to_json
            }
          end

          WebMock.stub_request(:post, %r|^#{host}/executions/.+/verify|).to_return do |request|
            log_info "[Shark][DoubleOptInService] Faking POST request"

            headers = { content_type: "application/vnd.api+json" }

            verification_token = request.uri.path.split("/")[2]
            object = ObjectCache.instance.objects.detect { |o| o["id"] === verification_token }

            if object.blank?
              {
                headers: headers,
                status: 404,
                body: { errors: [] }.to_json
              }
            else
              attributes = object["attributes"]
              is_execution_time_expired = Time.now.to_i > attributes["execution_expires_at"]
              is_verification_time_expired = Time.now.to_i > attributes["verification_expires_at"]

              is_number_of_verification_requests_exceeded =
                attributes["max_verifications"] > 0 &&
                attributes["max_verifications"] <= attributes["verifications_count"]

              if is_execution_time_expired
                {
                  headers: headers,
                  status: 404,
                  body: { errors: [] }.to_json
                }
              elsif is_verification_time_expired
                {
                  headers: headers,
                  status: 422,
                  body: { errors: [{ "code": "verification_expired" }] }.to_json
                }
              elsif is_number_of_verification_requests_exceeded
                {
                  headers: headers,
                  status: 422,
                  body: { errors: [{ "code": "exceeded_number_of_verification_requests" }] }.to_json
                }
              else
                {
                  headers: headers,
                  status: 200,
                  body: { data: object }.to_json
                }
              end
            end
          end
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
