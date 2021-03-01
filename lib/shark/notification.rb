# frozen_string_literal: true

module Shark
  class Notification < Base
    extend NotificationService::Resource

    custom_endpoint :bulk_creation, on: :collection, request_method: :post
    custom_endpoint :read_all, on: :collection, request_method: :patch

    def self.create_multiple(attributes)
      data = {
        data: {
          type: 'notifications',
          attributes: attributes
        }
      }

      bulk_creation(data)
    end
  end
end
