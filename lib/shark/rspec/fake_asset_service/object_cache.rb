module Shark
  module RSpec
    module FakeAssetService
      class ObjectCache
        include Singleton

        def initialize
          @objects = {}
        end

        def host
          Shark.configuration.asset_service.site
        end

        def self.clear
          instance.clear
        end

        def add(payload_data)
          id = payload_data.delete('id') || SecureRandom.uuid
          base_uri = "#{host}/assets"

          @objects[id] = {
            'id' => id,
            'attributes' => payload_data,
            'links' => {
              'download' => "#{base_uri}/public/#{id}",
              'upload' => "#{base_uri}/upload",
              'show' => "#{base_uri}/#{id}",
              'self' => "#{base_uri}/#{id}"
            }
          }
        end

        def add_raw(id, raw_data)
          @objects[id] = raw_data
        end

        def clear
          @objects = {}
        end

        def find(id)
          @objects[id]
        end

        def remove(id)
          @objects.delete(id)
        end

        def objects
          @objects.values
        end

        def objects=(new_objects)
          @objects = new_objects.map do |new_object|
            object_id = new_object['id']
            [object_id, new_object]
          end.to_h
        end
      end
    end
  end
end
