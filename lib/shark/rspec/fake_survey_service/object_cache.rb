# frozen_string_literal: true

module Shark
  module RSpec
    module FakeSurveyService
      class ObjectCache
        include Singleton
        attr_accessor :objects

        def initialize
          @objects = []
        end

        def self.clear
          instance.objects = []
        end

        def add(payload)
          payload['id'] = SecureRandom.uuid if payload['id'].blank?

          objects << payload unless objects.detect { |o| o['id'] == id }

          payload
        end

        def find(id, type)
          objects.detect { |o| o['id'] == id && o['type'] == type }
        end

        def remove(id, type)
          objects.delete_if { |o| o['id'] == id && o['type'] == type }
        end
      end
    end
  end
end
