# frozen_string_literal: true

module Shark
  module RSpec
    module FakeSubscriptionService
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
          id = payload_data.delete('id')

          if id && !objects.find { |subscription| subscription['id'] == id }
            object = {
              id: id,
              attributes: payload_data
            }

            objects << object
          else
            objects << {
              id: SecureRandom.uuid,
              attributes: payload_data
            }
          end
          objects.last
        end

        def add_multiple(payload_data)
          added = []
          payload_data.each { |subscription| added << add(subscription) }
          added.compact
        end

        def remove(id)
          objects.delete_if { |subscription| subscription[:id] == id }
        end

        def remove_multiple(payload_data)
          payload_data.each { |subscription| remove(subscription['id']) }
          objects
        end
      end
    end
  end
end
