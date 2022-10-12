# frozen_string_literal: true

module Shark
  module Middleware
    class Status < Faraday::Middleware
      def call(environment)
        @app.call(environment).on_complete do |env|
          handle_status(env[:status], env)

          if env[:body].is_a?(Hash)
            status = env[:body].fetch('meta', {}).fetch('status', 200).to_i
            handle_status(status, env)
          end
        end
      rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
        raise ConnectionError, e
      end

      private

      def handle_status(status, environment)
        return if (200..399).cover?(status)

        case status
        when 401 then raise NotAuthorized.new(status, environment)
        when 403 then raise AccessDenied.new(status, environment)
        when 404 then raise ResourceNotFound.new(status, environment)
        when 409 then raise ResourceConflict.new(status, environment)
        when 422 then raise UnprocessableEntity.new(status, environment)
        when 500..599 then raise ServerError.new(status, environment)
        else raise UnexpectedStatus.new(status, environment)
        end
      end
    end
  end
end
