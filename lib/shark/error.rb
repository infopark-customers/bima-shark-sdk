module Shark
  class Error < StandardError; end

  class ApiError < Error
    attr_reader :code, :env

    def initialize(code, env)
      @code = code
      @env = env
    end

    def body
      env[:body]
    end

    def url
      env[:url]
    end
  end

  class ConnectionError < ApiError
    def initialize(env)
      @env = env
    end
  end

  #
  # Client errors
  #
  class ClientError < ApiError; end
  class AccessDenied < ClientError; end
  class NotAuthorized < ClientError; end

  class ResourceConflict < ClientError
    def message
      "Resource already exists"
    end
  end

  class ResourceNotFound < ClientError
    def message
      "Couldn't find resource at: #{url}"
    end
  end

  class UnprocessableEntity < ClientError
    def errors
      body["errors"] || {}
    end

    def message
      errors.to_json
    end
  end

  #
  # Server errors
  #
  class ServerError < ApiError
    def message
      "Internal server error"
    end
  end

  class UnexpectedStatus < ServerError
    def message
      "Unexpected response status: #{code} from: #{url}"
    end
  end

  #
  # Other errors
  #
  class ActionNotSupportedError < Error; end
end
