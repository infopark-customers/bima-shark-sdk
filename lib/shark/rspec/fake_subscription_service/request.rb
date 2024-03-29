# frozen_string_literal: true

require 'webmock/rspec'

module Shark
  module RSpec
    module FakeSubscriptionService
      class Request
        include Singleton

        ALLOWED_FILTERS = %w[name subscriberId].freeze

        def self.setup
          instance = self.instance
          instance.stub_requests
        end

        def stub_requests
          WebMock.stub_request(:post, %r{^#{host}/subscriptions}).to_return do |request|
            log_info "Faking POST request with body: #{request.body}"

            payload_data = JSON.parse(request.body)['data']['attributes']

            object_data = ObjectCache.instance.add(payload_data)

            SharkSpec.fake_response(201, data: object_data)
          end

          WebMock.stub_request(
            :post,
            %r{^#{host}/subscriptions/bulk_creation}
          ).to_return do |request|
            log_info "Faking POST request with body: #{request.body}"

            payload_data = JSON.parse(request.body)['data']['attributes']['subscriptions']

            objects_data = ObjectCache.instance.add_multiple(payload_data)

            SharkSpec.fake_response(201, data: objects_data)
          end

          WebMock.stub_request(
            :post,
            %r{^#{host}/subscriptions/bulk_deletion}
          ).to_return do |request|
            log_info "Faking POST request with body: #{request.body}"

            payload_data = JSON.parse(request.body)['data']['attributes']['subscriptions']
            ObjectCache.instance.remove_multiple(payload_data)

            SharkSpec.fake_response(204, nil)
          end

          WebMock.stub_request(:delete, %r{^#{host}/subscriptions/.+}).to_return do |request|
            log_info "Faking DELETE request with body: #{request.body}"

            id = request.uri.path.split('/')[2]

            ObjectCache.instance.remove(id)

            SharkSpec.fake_response(204, nil)
          end

          WebMock.stub_request(:get, %r{^#{host}/subscriptions}).to_return do |request|
            log_info 'Faking GET request'

            query_parameters = request.uri.query_values

            objects_data = if query_parameters
                             params = {}
                             query_parameters.each do |key, value|
                               parsed_key = key.match(/filter\[(.*)\]/)[1].camelize(:lower)
                               params[parsed_key] = value if ALLOWED_FILTERS.include?(parsed_key)
                             end

                             ObjectCache.instance.objects.select do |subscription|
                               conditions = params.map do |param, value|
                                 subscription[:attributes][param] == value
                               end
                               conditions.all?
                             end
                           else
                             ObjectCache.instance.objects
                           end

            SharkSpec.fake_response(200, data: objects_data)
          end
        end

        def host
          Shark.configuration.subscription_service.site
        end

        def log_info(message)
          Shark.logger.info "[Shark::SubscriptionService] #{message}"
        end
      end
    end
  end
end
