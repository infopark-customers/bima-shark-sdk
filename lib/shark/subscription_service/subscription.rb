# frozen_string_literal: true

module Shark
  module SubscriptionService
    class Subscription < Base
      custom_endpoint :bulk_creation, on: :collection, request_method: :post
      custom_endpoint :bulk_deletion, on: :collection, request_method: :post

      def self.create_multiple(attributes)
        bulk_creation(subscriptions_attributes(attributes))
      end

      def self.destroy_multiple(attributes)
        bulk_deletion(subscriptions_attributes(attributes))
      end

      def save
        if self['id'].present?
          raise Shark::ActionNotSupportedError, 'Shark::SubscriptionService::Consent#save is not supported for persisted subscriptions'
        else
          super
        end
      end

      def update_attributes(_attributes = {})
        raise Shark::ActionNotSupportedError, 'Shark::SubscriptionService::Subscription#update_attributes is not supported'
      end

      private

      def self.subscriptions_attributes(attributes)
        {
          data: {
            type: 'bulk-subscriptions',
            attributes: {
              subscriptions: attributes
            }
          }
        }
      end
    end
  end
end
