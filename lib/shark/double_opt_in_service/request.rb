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
        timeout
        verification_url
        verification_link_text
        leeway_to_close_timeout
        max_verifications
      )

      attr_accessor *ATTRIBUTES

      def self.create(attributes)
        response = connection.run(:post, "/requests/", attributes)
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
