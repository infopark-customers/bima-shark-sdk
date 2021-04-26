# frozen_string_literal: true

module Shark
  module DoubleOptIn
    class Request < Base
      extend DoubleOptIn::Resource

      ATTRIBUTES = %w[
        payload
        request_type
        recipient
        subject
        header
        sub_header
        message
        verification_url
        verification_link_text
        message_footer_html
        timeout
        leeway_to_terminate
        max_verifications
      ].freeze

      attr_accessor(*ATTRIBUTES)

      def self.create(attributes)
        body = {
          data: {
            type: 'requests',
            attributes: attributes
          }
        }

        response = connection.request(:post, '/requests/', body: body)
        new(response.body['data'])
      end

      def initialize(data)
        ATTRIBUTES.each do |key|
          public_send("#{key}=", data['attributes'][key])
        end
      end
    end
  end
end
