module Shark
  module RSpec
    module FakeContactService
      class ObjectCache
        include Singleton
        attr_accessor :objects

        def initialize
          @objects = []
        end

        def self.clear
          instance.objects = []
        end

        def add(object)
          objects.push(object)
        end

        def search_objects(type, params)
          filtered_objects = []
          filters = params["filter"] && params["filter"]["filter"]
          condition, filter = filters.first

          if condition.present? && filter.present?
            filtered_objects = objects.select do |object|
              return false  unless object["type"] == type

              attribute_key, value = filter.first
              attribute = object["attributes"][attribute_key]

              case condition
              when "contains_word_prefixes"
                attribute.to_s.start_with?(value)
              when "contains_words"
                words = value.split(",").map(&:strip)
                words.include?(attribute.to_s)
              when "equals"
                attribute.to_s == value
              when "is_blank"
                attribute.blank?
              when "is_true"
                attribute == true
              else
                false
              end
            end
          end

          filtered_objects
        end
      end
    end
  end
end