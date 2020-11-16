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
          WebMock.stub_request(:get, uri_patterns[:resource]).to_return do |request|
            log_info "[Shark][AssetService] Faking GET request"

            id = extract_id_from_request_uri(request.uri)

            object_data = ObjectCache.instance.find(id)

            if object_data.present?
              SharkSpec.fake_response(200, data: object_data)
            else
              SharkSpec.fake_response(404, errors: [])
            end
          end

          WebMock.stub_request(:get, uri_patterns[:download]).to_return do |request|
            log_info "[Shark][AssetService] Faking GET request"

            public_id = extract_id_from_request_uri(request.uri)
            id = PublicId.decode_public_id(public_id)

            blob = ObjectCache.instance.find_blob(id)

            if blob.present?
              SharkSpec.fake_response(200, blob)
            else
              SharkSpec.fake_response(404, nil)
            end
          end

          WebMock.stub_request(:get, uri_patterns[:resources]).to_return do |request|
            log_info "[Shark][AssetService] Faking GET request"
            SharkSpec.fake_response(200, data: ObjectCache.instance.objects)
          end

          WebMock.stub_request(:delete, uri_patterns[:resource]).to_return do |request|
            log_info "[Shark][AssetService] Faking DELETE request"

            id = extract_id_from_request_uri(request.uri)

            ObjectCache.instance.remove(id)

            SharkSpec.fake_response(204, nil)
          end

          WebMock.stub_request(:post, uri_patterns[:resources]).to_return do |request|
            log_info "[Shark][AssetService] Faking POST request with body: #{request.body}"

            payload = get_payload(request.body)
            object_data = ObjectCache.instance.add(payload)

            SharkSpec.fake_response(200, data: object_data)
          end

          WebMock.stub_request(:post, uri_patterns[:recreate_variations]).to_return do |request|
            log_info "[Shark][AssetService] Faking POST request"

            id = extract_id_from_request_uri(request.uri)

            if ObjectCache.instance.find(id)
              SharkSpec.fake_response(204, nil)
            else
              SharkSpec.fake_response(404, errors: [])
            end
          end
        end

        def log_info(message)
          Shark.logger.info message
        end

        private

        def extract_id_from_request_uri(uri)
          path = uri.path
          base_path = path['/assets/public/'] ? '/assets/public' : '/assets'
          path.match(%r{#{base_path}/([^/]+)[/?]?})[1]
        end

        def uri_patterns
          base_uri = "#{host}/assets"
          id = '[^/]+'
          optional_query = '(\?.*)?'

          {
            resources: %r{\A#{base_uri}#{optional_query}\z},
            resource: %r{\A#{base_uri}/#{id}#{optional_query}\z},
            download: %r{\A#{base_uri}/public/#{id}#{optional_query}\z},
            recreate_variations: %r{\A#{base_uri}/#{id}/recreate_variations#{optional_query}\z}
          }
        end

        def get_payload(body)
          payload = JSON.parse(body)["data"]
          payload["attributes"]["id"] = payload["id"] if payload["id"]
          payload["attributes"]
        end
      end
    end
  end
end
