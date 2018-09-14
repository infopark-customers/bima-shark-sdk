module Shark
  module RSpec
    module Helpers
      module SubscriptionServiceHelper
        def stub_subscription_service
          FakeSubscriptionService.setup
        end

        def unstub_subscription_service
          FakeSubscriptionService.reset
        end
      end
    end
  end
end
