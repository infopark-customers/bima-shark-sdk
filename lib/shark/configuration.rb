module Shark
  class Configuration
    attr_accessor :client_app_name, :contact_service, :form_service, :survey_service

    def initialize
      @contact_service = Shark::ContactService::Configuration.new
      @form_service = Shark::FormService::Configuration.new
      @survey_service = Shark::SurveyService::Configuration.new
    end
  end
end
