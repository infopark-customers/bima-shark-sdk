require_relative "fake_consent_service/object_cache"
require_relative "fake_consent_service/request"

module Shark
  module RSpec
    module FakeConsentService
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
