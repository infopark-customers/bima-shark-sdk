module Shark
  module RSpec
    module FakeAssetService
      class ObjectCache
        include Singleton
        attr_accessor :objects

        def initialize
          @objects = []
        end

        def self.clear
          instance.objects = []
        end

        def add(payload_data)
          id = payload_data.delete("id")

          if id && !find(id)
            object = {
              "id" => id,
              "attributes" => payload_data
            }

            objects << object
          else
            objects << {
              "id" => SecureRandom.uuid,
              "attributes" => payload_data
            }
          end
          objects.last
        end

        def find(id)
          objects.find {|asset| asset["id"] == id }
        end

        def remove(id)
          objects.delete_if{|asset| asset["id"] == id }
        end

      end
    end
  end
end