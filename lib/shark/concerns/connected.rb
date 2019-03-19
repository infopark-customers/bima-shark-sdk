module Shark
  module Connected
    extend ActiveSupport::Concern

    delegate :connection, to: :class

    included do
      class_attribute :connection_options

      self.connection_options = {
        headers: {
          "Content-Type" => "application/vnd.api+json",
          "Accept" => "application/vnd.api+json",
          "X-Forwarded-Proto" => "https"
        }
      }
    end

    module ClassMethods
      # Return/build a connection object
      #
      # @return [Connection] The connection to the api server
      # @api public
      def connection(rebuild = false, &block)
        _build_connection(rebuild, &block)
        @connection
      end


      protected

      # @api private
      def _build_connection(rebuild = false)
        return @connection  unless @connection.nil? || rebuild

        options = connection_options.merge(site: site)
        @connection = Shark::Client::Connection.new(options).tap do |conn|
          yield(conn)  if block_given?
        end
      end
    end
  end
end
