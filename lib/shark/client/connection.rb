module Shark
  module Client
    class Connection
      attr_reader :site, :connection_options

      def initialize(options = {})
        @site = options.fetch(:site)
        @connection_options = {}
        @connection_options[:headers] = options.fetch(:headers)

        @connection = Faraday.new do |faraday|
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
        options = request_options(params, headers)

        BimaHttp.request(action, url, options)
      end

      private

      def request_options(params = {}, headers = {})
        options = connection_options.reverse_merge(params: {}, headers: {})
        options[:headers] = options[:headers].merge(headers)
        options[:params] = options[:params].merge(params)
        options[:connection] = @connection
        if Shark.service_token.present?
          options[:headers]["Authorization"] = "Bearer #{Shark._service_token}"
        end

        options
      end
    end
  end
end
