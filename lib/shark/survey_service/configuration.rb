module Shark
  module SurveyService
    class Configuration
      def headers
        SurveyService::Base.connection_options[:headers]
      end

      def headers=(new_headers)
        SurveyService::Base.connection_options[:headers] = new_headers
      end

      def site
        SurveyService::Base.site
      end

      def site=(url)
        SurveyService::Base.site = url
      end
    end
  end
end
