module Shark
  module DoubleOptInService
    class Verification < Base
      def self.all
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Verification.all is not supported"
      end

      def update_attributes(attributes = {})
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Verification#update_attributes is not supported"
      end

      def destroy
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Verification#destroy is not supported"
      end

      def save
        if self["id"].present?
          raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Verification#save is not supported for persisted verification"
        else
          super
        end
      end
    end
  end
end
