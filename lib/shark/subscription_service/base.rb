module Shark
  module SubscriptionService
    class Base < ::Shark::Base
      def self.site
        ::Shark.configuration.subscription_service.site
      end
    end
  end
end