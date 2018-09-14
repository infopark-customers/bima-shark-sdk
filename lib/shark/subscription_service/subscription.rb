module Shark
  module SubscriptionService
    class Subscription < Base
      custom_endpoint :bulk_creation, on: :collection, request_method: :post
      custom_endpoint :bulk_deletion, on: :collection, request_method: :post

      def self.create_multiple(attributes)
        self.bulk_creation(subscriptions_attributes(attributes))
      end

      def self.destroy_multiple(attributes)
        self.bulk_deletion(subscriptions_attributes(attributes))
      end

      private

      def subscriptions_attributes(attributes)
        {
          data: {
            type: 'bulk-subscriptions',
            attributes: attributes
          }
        }
      end
    end
  end
end