module Shark
  module NotificationService
    class Notification < Base
      custom_endpoint :bulk_creation, on: :collection, request_method: :post
      custom_endpoint :read_all, on: :collection, request_method: :patch


      def self.create_multiple(attributes)
        data = {
          data: {
            type: 'notifications',
            attributes: attributes
          }
        }

        self.bulk_creation(data)
      end
    end
  end
end
