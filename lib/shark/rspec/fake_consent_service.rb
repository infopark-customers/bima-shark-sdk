require_relative "fake_consent_service/request"

module Shark
  module RSpec
    module FakeConsentService
      def self.setup
        Request.setup
      end
    end
  end
end
