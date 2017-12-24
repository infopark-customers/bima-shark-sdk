module Shark
  module SurveyService
    class Base < ::Shark::Base
      def self.site
        File.join(::Shark.configuration.survey_service.site, "/api/v1/projects")
      end

      def self.find(*args)
        super.first
      end
    end
  end
end
