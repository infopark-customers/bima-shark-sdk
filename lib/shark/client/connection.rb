module Shark
  module Client
    class Connection
      HTTP_METHODS_WITH_BODY = [:post, :patch, :put]

      attr_reader :site, :connection_options

      def initialize(options = {})
        @site = options.fetch(:site)
        @connection_options = {}
        @connection_options[:headers] = options.fetch(:headers)

        @connection = Faraday.new do |faraday|
          faraday.use Shark::Middleware::ComposeRequest
          faraday.use Shark::Middleware::Status
          faraday.use JsonApiClient::Middleware::ParseJson
          faraday.adapter :net_http_persistent
        end
      end

      def use(middleware, *args, &block); end

      def run(action, path, params = {}, headers = {})
        raise ArgumentError, "Configuration :site cannot be nil"  if site.blank?
        raise ArgumentError, "Parameter :path cannot be nil"      if path.blank?

        url = File.join(site, path)
        headers = request_headers(headers)
        params = request_params(params)

        if request_with_body?(action)
          @connection.send(action) do |request|
            request.url(url)
            request.headers.merge!(headers)
            request.body = params
          end
        else
          @connection.send(action) do |request|
            request.url(url)
            request.headers.merge!(headers)
            request.params.merge!(params)
          end
        end
      end


      private

      def request_headers(req_headers = {})
        headers = connection_options[:headers] || {}
        headers = headers.merge(req_headers)
        if Shark.service_token.present?
          headers["Authorization"] = "Bearer #{Shark._service_token}"
        end

        headers
      end

      def request_params(req_params = {})
        params = connection_options[:params] || {}
        params.merge(req_params)
      end

      def request_with_body?(action)
        HTTP_METHODS_WITH_BODY.include?(action.to_sym)
      end
    end
  end
end
