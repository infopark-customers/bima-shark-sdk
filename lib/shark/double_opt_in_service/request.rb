module Shark
  module DoubleOptInService
    class Request < Base
      custom_endpoint :verify, on: :member, request_method: :post

      def self.verify(verification_token)
        double_opt_in_request = find(verification_token).first
        double_opt_in_request.verify.first
      end

      def self.close(verification_token)
        double_opt_in_request = find(verification_token).first
        double_opt_in_request.destroy
        double_opt_in_request
      end

      # def self.verify_and_close(verification_token)
      #   double_opt_in_request = find(verification_token).first
      #   double_opt_in_request.verify
      #   double_opt_in_request.destroy
      # end

      def self.all
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Request.all is not supported"
      end

      def update_attributes(attributes = {})
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Request#update_attributes is not supported"
      end

      # TODO
      # def destroy
      #   raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Request#destroy is not supported"
      # end

      def save
        if self["id"].present?
          raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Request#save is not supported for persisted request"
        else
          super
        end
      end
    end
  end
end
