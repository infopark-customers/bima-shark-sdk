require 'webmock/rspec'

module Shark
  module RSpec
    module FakeMailingService
      class Request
        include Singleton

        def self.setup
          instance = self.instance
          instance.stub_requests
        end

        def stub_requests
          WebMock.stub_request(:post, %r|^#{host}/mails|).to_return do |request|
            log_info "[Shark][MailingService] Faking POST request with body: #{request.body}"

            id = SecureRandom.hex
            payload_data = JSON.parse(request.body)['data']

            SharkSpec.fake_response(201, data: {
              type: 'notifications',
              id: id,
              attributes: payload_data
            })
          end
        end

        def host
          Shark.configuration.mailing_service.site
        end

        def log_info(message)
           message
        end
      end
    end
  end
end
