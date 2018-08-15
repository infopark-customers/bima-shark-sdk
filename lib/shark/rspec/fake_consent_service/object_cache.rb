module Shark
  module RSpec
    module FakeConsentService
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
          id = payload_data["attributes"]["legal_subject_id"]
          existing_object = objects.detect { |o| o["id"] == id }

          items = (existing_object.present? && existing_object["attributes"]["items"]) || {}

          (payload_data["attributes"]["items"] || {}).each do |name, attrs|
            items[name] = attrs.merge({ "updated_at" => Time.now })
          end

          objects.delete_if { |o| o["id"] == id }

          object = {
            "id" => id,
            "attributes" => {
              "items" => items
            },
            "type" => "consents"
          }

          objects.push(object)
          object
        end
      end
    end
  end
end
