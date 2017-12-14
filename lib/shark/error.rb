module Shark
  class ApiError < StandardError
    attr_reader :env
    def initialize(env)
      @env = env
    end
  end

  class ClientError < ApiError; end
  class AccessDenied < ClientError; end
  class NotAuthorized < ClientError; end

  class ConnectionError < ApiError; end

  class ServerError < ApiError
    def message
      "Internal server error"
    end
  end

  class ResourceConflict < ServerError
    def message
      "Resource already exists"
    end
  end

  class ResourceNotFound < ServerError
    attr_reader :uri
    def initialize(uri)
      @uri = uri
    end

    def message
      "Couldn't find resource at: #{uri}"
    end
  end

  class UnprocessableEntity < ServerError
    attr_reader :errors

    def initialize(body)
      @errors = body["errors"] || {}
    end

    def message
      errors.to_json
    end
  end

  class UnexpectedStatus < ServerError
    attr_reader :code, :uri

    def initialize(code, uri)
      @code = code
      @uri = uri
    end

    def message
      "Unexpected response status: #{code} from: #{uri}"
    end
  end
end