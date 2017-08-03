module Shark
  module FormService
    class Configuration
      def headers
        FormService::Base.connection_options[:headers]
      end

      def headers=(new_headers)
        FormService::Base.connection_options[:headers] = new_headers
      end

      def site
        FormService::Base.site
      end

      def site=(url)
        FormService::Base.site = url
      end
    end
  end
end
