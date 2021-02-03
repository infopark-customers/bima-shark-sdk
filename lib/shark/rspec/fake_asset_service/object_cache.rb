# frozen_string_literal: true

module Shark
  module RSpec
    module FakeAssetService
      class ObjectCache
        include Singleton

        def initialize
          @objects = {}
          @blobs = {}
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
          public_id = PublicId.encode_id(id)

          @objects[id] = {
            'id' => id,
            'attributes' => payload_data,
            'links' => {
              'download' => "#{base_uri}/public/#{public_id}",
              'upload' => "#{base_uri}/#{id}/upload",
              'show' => "#{base_uri}/#{id}",
              'self' => "#{base_uri}/#{id}"
            }
          }
        end

        def add_blob(id, blob)
          @blobs[id] = blob
        end

        def clear
          @objects = {}
        end

        def find(id)
          @objects[id]
        end

        def find_blob(id)
          @blobs[id]
        end

        def remove(id)
          @objects.delete(id)
        end

        def remove_blob(id)
          @blobs.delete(id)
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
