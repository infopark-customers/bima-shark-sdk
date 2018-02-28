module Shark
  module Middleware
    class ComposeRequest < Faraday::Middleware
      HTTP_METHODS_WITH_BODY = [:post, :patch, :put]
      CONTENT_TYPE         = "Content-Type".freeze
      JSON_MIME_TYPE       = "application/json".freeze
      JSON_MIME_TYPE_REGEX = /^application\/(vnd\..+\+)?json$/

      def call(env)
        if request_with_body?(env)
          compose_request_body(env)
        end

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
        type = type.split(';', 2).first  if type.index(';')
        type
      end
    end
  end
end
