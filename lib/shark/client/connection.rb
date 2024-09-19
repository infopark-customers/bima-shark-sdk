# frozen_string_literal: true

module Shark
  module Client
    class Connection
      attr_reader :site, :connection_options

      def initialize(options = {})
        @site = options.fetch(:site)
        @connection_options = {
          headers: options[:headers] || {},
          params: options[:params] || {}
        }

        @connection = Faraday.new do |conn|
          conn.use Shark::Middleware::ComposeRequest
          conn.use Shark::Middleware::Status
          conn.response :json, content_type: /\bjson$/
          conn.adapter Faraday.default_adapter
        end
      end

      def use(middleware, *args, &block); end

      # @param request_action [Symbol] One of :get, :post, :put, :patch, :delete.
      # @param path [String] The url path
      # @param options [Hash]
      #   - params [Hash] The request params
      #   - headers [Hash] The request headers
      #   - body [Hash]
      # @return [Faraday::Response]
      # @api private
      def run(request_action, path, params: {}, headers: {}, body: nil)
        raise ArgumentError, 'Configuration :site cannot be nil' if site.blank?
        raise ArgumentError, 'Parameter :path cannot be nil' if path.blank?

        url = File.join(site, path)
        request_headers = connection_options_headers.merge(headers || {})
        request_params = connection_options_params.merge(params || {})

        if Shark.service_token.present?
          request_headers['Authorization'] = "Bearer #{Shark.service_token}"
        end

        @connection.send(request_action) do |request|
          request.url(url)
          request.headers.merge!(request_headers)
          request.body = body
          request.params.merge!(request_params)
        end
      end

      # @see request
      alias request run

      private

      def connection_options_headers
        connection_options[:headers] || {}
      end

      def connection_options_params
        connection_options[:params] || {}
      end
    end
  end
end
