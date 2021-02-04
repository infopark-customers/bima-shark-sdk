# frozen_string_literal: true

require_relative 'fake_subscription_service/object_cache'
require_relative 'fake_subscription_service/request'

module Shark
  module RSpec
    module FakeSubscriptionService
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
