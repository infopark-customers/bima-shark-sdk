# frozen_string_literal: true

require_relative 'fake_notification_service/request'

module Shark
  module RSpec
    module FakeNotificationService
      def self.setup
        Request.setup
      end
    end
  end
end
