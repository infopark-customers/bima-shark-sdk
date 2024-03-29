# frozen_string_literal: true

module Shark
  module Middleware
    class ComposeRequest < Faraday::Middleware
      HTTP_METHODS_WITH_BODY = %i[post patch put].freeze
      CONTENT_TYPE = 'Content-Type'
      JSON_MIME_TYPE = 'application/json'
      JSON_MIME_TYPE_REGEX = %r{^application/(vnd\..+\+)?json$}.freeze

      def call(env)
        compose_request_body(env) if request_with_body?(env)

        @app.call(env)
      end

      def request_with_body?(env)
        HTTP_METHODS_WITH_BODY.include?(env[:method])
      end

      def compose_request_body(env)
        type = request_type(env)
        params = env[:body] || {}

        params = if JSON_MIME_TYPE_REGEX =~ type
                   ::JSON.dump(params)
                 else
                   params.to_param
                 end

        env[:body] = params
      end

      def request_type(env)
        type = env[:request_headers][CONTENT_TYPE].to_s
        type = type.split(';', 2).first if type.index(';')
        type
      end
    end
  end
end
