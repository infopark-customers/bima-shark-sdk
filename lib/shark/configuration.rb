module Shark
  class Configuration
    attr_accessor :client_app_name, :form_service, :survey_service
    attr_writer :use_bima_http

    def use_bima_http?
      @use_bima_http.present?
    end

    def initialize
      @survey_service = Shark::SurveyService::Configuration.new
      @form_service = Shark::FormService::Configuration.new
    end
  end
end
