module Shark
  module RSpec
    module Helpers
      module Response
        def fake_response(status, body)
          {
            headers: {
              content_type: 'application/vnd.api+json'
            },
            status: status,
            body: body.is_a?(String) ? body : body.to_json
          }
        end
      end
    end
  end
end