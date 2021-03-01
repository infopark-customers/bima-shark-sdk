# frozen_string_literal: true

require 'webmock/rspec'

module Shark
  module RSpec
    module FakeSurveyService
      class Request
        include Singleton

        attr_accessor :cache

        def self.setup
          instance = self.instance
          instance.stub_requests
          instance.cache = ObjectCache.instance
        end

        def stub_requests
          WebMock.stub_request(:post, %r{^#{host}/.*$}).to_return do |request|
            log "POST #{request.uri}"
            log "Body #{request.body}"

            payload = JSON.parse(request.body)['data']
            object = cache.add(payload)

            SharkSpec.fake_response(201, data: object)
          end

          WebMock.stub_request(:delete, %r{^#{host}/.+/.+}).to_return do |request|
            log "DELETE #{request.uri}"

            id = request.uri.path.split('/')[2]

            ObjectCache.instance.remove(id)

            SharkSpec.fake_response(204, nil)
          end

          WebMock.stub_request(:get, %r{^#{host}/.+/.+}).to_return do |request|
            log "GET #{request.uri}"

            type = request.uri.path.split('/')[4]
            id = request.uri.path.split('/')[5]

            object = cache.find(id, type)

            if object.present?
              SharkSpec.fake_response(200, data: object)
            else
              SharkSpec.fake_response(404, errors: [])
            end
          end
        end

        def host
          Shark.configuration.survey_service.site
        end

        def log(message)
          Shark.logger.info "[Shark] #{message}"
        end
      end
    end
  end
end
