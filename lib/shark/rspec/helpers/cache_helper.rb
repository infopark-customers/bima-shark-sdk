# frozen_string_literal: true

module Shark
  module RSpec
    module Helpers
      module CacheHelper
        def find(type, id)
          objects.detect { |o| o['type'] == type && o['id'] == id }
        end

        def included_resources(object_or_objects, params)
          return [] unless params['include'].present?

          relationships = params['include'].split(',')
          included_objects = []

          to_array(object_or_objects).each do |object|
            relationships.each do |name|
              rdata = object.dig('relationships', name, 'data')
              to_array(rdata).each do |r|
                included_objects << find(r['type'], r['id'])
              end
            end
          end

          included_objects.compact
        end

        private

        def to_array(object_or_objects)
          case object_or_objects
          when Hash
            [object_or_objects]
          when Array
            object_or_objects
          else
            Array(object_or_objects)
          end
        end
      end
    end
  end
end
