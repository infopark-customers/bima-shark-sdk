module Shark
  module DoubleOptInService
    class Execution < Base
      attr_accessor :payload, :request_type

      def self.verify(verification_token)
        response = connection.run(:post, "/executions/#{verification_token}/verify")
        new(response.body["data"])
      rescue UnprocessableEntity => e
        if caused_by_error_code?(e.errors, 'exceeded_number_of_verification_requests')
          raise ExceededNumberOfVerificationRequestsError
        else
          raise e
        end
      end

      def self.find(verification_token)
        response = connection.run(:get, "/executions/#{verification_token}")
        new(response.body["data"])
      rescue UnprocessableEntity => e
        if caused_by_error_code?(e.errors, 'requested_unverified_execution')
          raise RequestedUnverifiedExecutionError
        else
          raise e
        end
      end

      def self.terminate(verification_token)
        response = connection.run(:delete, "/executions/#{verification_token}")
        new(response.body["data"])
      end

      def initialize(data)
        %w(payload request_type).each do |key|
          public_send("#{key}=", data["attributes"][key])
        end
      end


      private

      def caused_by_error_code?(errors, error_code)
        errors.detect { |error| error['code'] === error_code }
      end
    end
  end
end
