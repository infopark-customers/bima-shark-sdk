module Shark
  module RSpec
    module FakeDoubleOptInService
      class ObjectCache
        include Singleton
        attr_accessor :objects

        def initialize
          @objects = []
        end

        def self.clear
          instance.objects = []
        end

        def add_execution(attributes)
          verification_token = SecureRandom.hex

          object = {
            "id" => verification_token,
            "attributes" => attributes,
            "type" => "executions"
          }

          objects.push(object)
          object
        end

        def create_request(attributes)
          timeout = attributes["timeout"] || 3600
          leeway_to_terminate = attributes["leeway_to_terminate"] || 3600

          verification_expires_at = Time.now.to_i + timeout.to_i
          execution_expires_at = verification_expires_at + leeway_to_terminate.to_i

          add_execution({
            "payload" => attributes["payload"],
            "request_type" => attributes["request_type"],
            "max_verifications" => attributes["max_verifications"] || 0,
            "verifications_count" => 0,
            "verification_expires_at" => verification_expires_at,
            "execution_expires_at" => execution_expires_at
          })

          attributes
        end
      end
    end
  end
end
