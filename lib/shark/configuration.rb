module Shark
  class Configuration
    attr_accessor :client_app_name, :form_service, :survey_service

    def initialize
      @survey_service = Shark::SurveyService::Configuration.new
      @form_service = Shark::FormService::Configuration.new
    end

    def _service_token=(token)
      @service_token = token
    end

    def _service_token
      @service_token
    end
  end
end
