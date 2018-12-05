require_relative "fake_double_opt_in_service/object_cache"
require_relative "fake_double_opt_in_service/request"

module Shark
  module RSpec
    module FakeDoubleOptInService
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
