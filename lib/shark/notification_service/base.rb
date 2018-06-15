module Shark
  module NotificationService
    class Base < ::Shark::Base
      def self.site
        ::Shark.configuration.notification_service.site
      end
    end
  end
end
