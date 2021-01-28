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
              SharkSpec.fake_response(200, data: object_data)
            else
              SharkSpec.fake_response(404, errors: [])
            end
          end

          WebMock.stub_request(:get, %r|^#{host}/assets|).to_return do |request|
            log_info "[Shark][AssetService] Faking GET request"
            SharkSpec.fake_response(200, data: ObjectCache.instance.objects)
          end

          WebMock.stub_request(:delete, %r|^#{host}/assets/.+|).to_return do |request|
            log_info "[Shark][AssetService] Faking DELETE request"

            id = request.uri.path.split("/")[2]

            ObjectCache.instance.remove(id)

            SharkSpec.fake_response(204, nil)
          end

          WebMock.stub_request(:post, %r|^#{host}/assets|).to_return do |request|
            log_info "[Shark][AssetService] Faking POST request with body: #{request.body}"

            payload = get_payload(request.body)
            object_data = ObjectCache.instance.add(payload)

            SharkSpec.fake_response(200, data: object_data)
          end

          WebMock.stub_request(:post, %r|^#{host}/assets/.+/recreate_variations|).to_return do |request|
            log_info "[Shark][AssetService] Faking POST request"

            id = request.uri.path.split("/")[2]

            if ObjectCache.instance.find(id)
              SharkSpec.fake_response(204, nil)
            else
              SharkSpec.fake_response(404, errors: [])
            end
          end

          WebMock.stub_request(:post, %r|^#{host}/packages|).to_return do |request|
            log_info "[Shark][AssetService] Faking POST request with body: #{request.body}"

            payload = get_payload(request.body)

            package_data = {
              attributes: {
                filename: payload['filename'],
                directory: payload['directory']
              }
            }

            object_data = ObjectCache.instance.add(package_data)

            SharkSpec.fake_response(200, data: object_data)
          end

          WebMock.stub_request(:get, %r|^#{host}/.+/download|).to_return do |request|
            log_info '[Shark][AssetService] Faking GET download request'

            SharkSpec.fake_response(200, body: 'Lorem ipsum')
          end

          WebMock.stub_request(:put, %r|^#{host}/.+/upload|).to_return do |request|
            log_info '[Shark][AssetService] Faking PUT upload request'

            id = request.uri.path.split("/")[2]
            object_data = ObjectCache.instance.find(id)

            if object_data.present?
              object_data['attributes']['uploaded-at'] = 1
            end

            SharkSpec.fake_response(200, body: '<response>true</response>')
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
