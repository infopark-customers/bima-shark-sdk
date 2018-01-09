require_relative "fake_contact_service/object_cache"
require_relative "fake_contact_service/request"

module Shark
  module RSpec
    module FakeContactService
      def self.setup
        ObjectCache.clear
        Request.setup
      end

      def self.reset
        ObjectCache.clear
      end
    end
  end
end
