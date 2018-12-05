module Shark
  module DoubleOptInService
    class Request < Base
      ATTRIBUTES = %w(
        payload
        request_type
        recipient
        subject
        header
        sub_header
        message
        verification_url
        verification_link_text
        timeout
        leeway_to_terminate
        max_verifications
      )

      attr_accessor *ATTRIBUTES

      def self.create(attributes)
        body = {
          data: {
            type: "requests",
            attributes: attributes
          }
        }

        response = connection.run(:post, "/requests/", body)
        new(response.body["data"])
      end

      def initialize(data)
        ATTRIBUTES.each do |key|
          public_send("#{key}=", data["attributes"][key])
        end
      end
    end
  end
end
