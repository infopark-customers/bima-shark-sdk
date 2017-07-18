module Shark
  class Configuration
    attr_accessor :client_app_name, :survey_service
    attr_writer :use_bima_http

    def use_bima_http?
      @use_bima_http.present?
    end

    def initialize
      @survey_service = Shark::SurveyService::Configuration.new
    end
  end
end
