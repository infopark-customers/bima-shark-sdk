# frozen_string_literal: true

require_relative 'fake_double_opt_in/object_cache'
require_relative 'fake_double_opt_in/request'

module Shark
  module RSpec
    module FakeDoubleOptIn
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
