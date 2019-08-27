require_relative "fake_mailing_service/request"

module Shark
  module RSpec
    module FakeMailingService
      def self.setup
        Request.setup
      end
    end
  end
end
