module Shark
  module DoubleOptInService
    class Request < Base
      custom_endpoint :verify, on: :member, request_method: :post

      def self.verify(verification_token)
        request = find(verification_token).first
        request.verify.first
      end

      def self.close(verification_token)
        request = find(verification_token).first
        request_attributes = request.attributes.dup
        request.destroy
        new(request_attributes)
      end

      def self.all
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Request.all is not supported"
      end

      def update_attributes(attributes = {})
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Request#update_attributes is not supported"
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
