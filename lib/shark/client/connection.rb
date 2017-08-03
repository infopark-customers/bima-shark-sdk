module Shark
  module Client
    class Connection
      attr_reader :site, :connection_options

      def initialize(options = {})
        @site = options.fetch(:site)
        @connection_options = options.slice(:app_name, :params)
        @connection_options[:headers] = options.fetch(:headers)

        @connection = Faraday.new do |faraday|
          faraday.use Shark::Middleware::Status
          faraday.use JsonApiClient::Middleware::ParseJson
          faraday.adapter :net_http_persistent
        end
      end

      def use(_middleware, *_args, &_block); end

      def run(action, path, params = {}, headers = {})
        raise ArgumentError, 'Configuration :site cannot be nil' if site.blank?
        raise ArgumentError, 'Parameter :path cannot be nil' if path.blank?

        url = File.join(site, path)
        options = request_options(params, headers)

        BimaHttp.request(action, url, options)
      end

      protected

      def request_options(params = {}, headers = {})
        options = connection_options.reverse_merge(params: {}, headers: {})
        options[:headers] = options[:headers].merge(headers)
        options[:params] = options[:params].merge(params)
        if options[:headers]['Authorization'].blank? && Shark.configuration.use_bima_http?
          options[:app_name] = Shark.configuration.client_app_name
        end
        options[:connection] = @connection
        options
      end
    end
  end
end
