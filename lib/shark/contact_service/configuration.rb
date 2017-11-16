module Shark
  module ContactService
    class Configuration
      def headers
        ContactService::Base.connection_options[:headers]
      end

      def headers=(new_headers)
        ContactService::Base.connection_options[:headers] = new_headers
      end

      def site
        ContactService::Base.site
      end

      def site=(url)
        ContactService::Base.site = url
      end
    end
  end
end
