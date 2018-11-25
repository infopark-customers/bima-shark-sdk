module Shark
  module DoubleOptInService
    class Request < Base
      def self.find(id)
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Request.all is not supported"
      end

      def self.all
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Request.all is not supported"
      end

      # TODO add .where?

      def update_attributes(attributes = {})
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Request#update_attributes is not supported"
      end

      def destroy
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Request#destroy is not supported"
      end

      def save
        if self["id"].present?
          raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Request#save is not supported for persisted requests"
        else
          super
        end
      end
    end
  end
end
