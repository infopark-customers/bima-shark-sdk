# frozen_string_literal: true

module Shark
  module RSpec
    module Helpers
      module Response
        def fake_response(status, body)
          serialized_body = if body.nil? || body.is_a?(String)
                              body
                            else
                              body.to_json
                            end

          {
            headers: {
              content_type: 'application/vnd.api+json'
            },
            status: status,
            body: serialized_body
          }
        end
      end
    end
  end
end
