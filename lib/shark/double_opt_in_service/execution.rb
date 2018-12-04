module Shark
  module DoubleOptInService
    class Execution < Base
      attr_accessor :payload, :request_type

      def self.find(verification_token)
        response = connection.run(:get, "/executions/#{verification_token}")
        new(response.body["data"])
      end

      def self.verify(verification_token)
        response = connection.run(:post, "/executions/#{verification_token}/verify")
        new(response.body["data"])
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
    end
  end
end
