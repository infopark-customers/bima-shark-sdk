module Shark
  class Configuration

    #
    # Helper class for service configuration
    #
    ServiceConfiguration = Struct.new(:service_base) do
      def headers
        service_base.connection_options[:headers]
      end

      def headers=(value)
        service_base.connection_options[:headers] = service_base.connection_options[:headers].merge(value)
      end

      def site
        @site
      end

      def site=(url)
        @site = url
      end
    end

    #
    # Shark Configuration
    #
    attr_accessor :logger, :cache
    attr_accessor :contact_service, :form_service, :survey_service

    def initialize
      @contact_service = ServiceConfiguration.new(ContactService::Base)
      @form_service = ServiceConfiguration.new(FormService::Base)
      @survey_service = ServiceConfiguration.new(SurveyService::Base)
    end

    # Within the given block, add the service token authorization header to all api requests.
    #
    # @param token [String] The service token for the authorization header
    # @param block [Block] The block where service token authorization will be set for
    # @api public
    def with_service_token(token)
      if token.is_a?(String)
        self.service_token = token
      elsif token.responds_to?(:jwt)
        self.service_token = token.jwt
      else
        raise ArgumentError, "Parameter :token must be kind of String."
      end

      yield
    ensure
      self.service_token = nil
    end

    # @api public
    def service_token
      Thread.current["shark-service-token"]
    end


    private

    # @api private
    def service_token=(value)
      Thread.current["shark-service-token"] = value
    end
  end
end
