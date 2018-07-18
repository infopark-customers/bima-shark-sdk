module Shark
  module RSpec
    module Helpers
      module NotificationServiceHelper
        def stub_notification_service
          FakeNotificationService.setup
        end
      end
    end
  end
end
