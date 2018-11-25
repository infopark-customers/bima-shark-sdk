module Shark
  module DoubleOptInService
    class Execution < Base
      custom_endpoint :verify, on: :member, request_method: :post

      def self.verify(verification_token)
        execution = find(verification_token).first
        execution.verify.first
      end

      def self.close(verification_token)
        execution = find(verification_token).first
        execution_attributes = execution.attributes.dup
        execution.destroy
        new(execution_attributes)
      end

      # TODO add .where?

      def self.create(attributes)
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Execution.create is not supported"
      end

      def self.all
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Execution.all is not supported"
      end

      def update_attributes(attributes = {})
        raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Execution#update_attributes is not supported"
      end

      def save
        if self["id"].present?
          raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Execution#save is not supported for persisted executions"
        else
          super
        end
      end
    end
  end
end
