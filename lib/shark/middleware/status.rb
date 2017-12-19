module Shark
  module Middleware
    class Status < Faraday::Middleware
      def call(environment)
        @app.call(environment).on_complete do |env|
          handle_status(env[:status], env)

          if env[:body].is_a?(Hash)
            status = env[:body].fetch("meta", {}).fetch("status", 200).to_i
            handle_status(status, env)
          end
        end
      rescue Faraday::ConnectionFailed, Faraday::TimeoutError
        raise ConnectionError, environment
      end


      private

      def handle_status(status, environment)
        return if (200..399).cover?(status)

        case status
        when 401 then raise NotAuthorized, environment
        when 403 then raise AccessDenied, environment
        when 404 then raise ResourceNotFound, environment[:url]
        when 409 then raise ResourceConflict, environment
        when 422 then raise UnprocessableEntity, environment[:body]
        when 500..599 then raise ServerError, environment
        else raise UnexpectedStatus, status, environment[:url]
        end
      end
    end
  end
end
