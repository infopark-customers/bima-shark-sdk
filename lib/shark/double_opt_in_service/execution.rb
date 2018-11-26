module Shark
  module DoubleOptInService
    class Execution
      include Connected

      attr_accessor :payload, :request_type, :closure_expires_at

      def self.site
        ::Shark.configuration.double_opt_in_service.site
      end

      def self.verify(verification_token)
        response = connection.run(
          :post,
          "/executions/#{verification_token}/verify"
        )

        new(response.body["data"])
      end

      def self.destroy(verification_token)
        response = connection.run(
          :delete,
          "/executions/#{verification_token}"
        )

        new(response.body["data"])
      end

      def initialize(data)
        %w(payload request_type closure_expires_at).each do |key|
          public_send("#{key}=", data["attributes"][key])
        end
      end




      # custom_endpoint :verify, on: :member, request_method: :post
      #
      # def self.verify(verification_token)
      #   execution = find(verification_token).first
      #   execution.verify.first
      # end
      #
      # def self.close(verification_token)
      #   execution = find(verification_token).first
      #   execution_attributes = execution.attributes.dup
      #   execution.destroy
      #   new(execution_attributes)
      # end
      #
      # def self.create(attributes)
      #   raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Execution.create is not supported"
      # end
      #
      # def self.all
      #   raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Execution.all is not supported"
      # end
      #
      # def update_attributes(attributes = {})
      #   raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Execution#update_attributes is not supported"
      # end
      #
      # def save
      #   if self["id"].present?
      #     raise Shark::ActionNotSupportedError, "Shark::DoubleOptInService::Execution#save is not supported for persisted executions"
      #   else
      #     super
      #   end
      # end
    end
  end
end
