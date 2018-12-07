require "bundler/setup"
require "pry"
require "shark"
require "bima-shark-sdk/rspec"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  Shark.configure do |config|
    config.asset_service.site = "https://asset-service.example.com"
    config.contact_service.site = "https://contact-service.example.com"
    config.form_service.site = "https://form-service.example.com"
    config.survey_service.site = "https://milacrm.example.com"
    config.notification_service.site = "https://notification-service.example.com"
    config.consent_service.site = "https://consent-service.example.com"
    config.subscription_service.site = "https://subscription-service.example.com"
  end

  config.before do
    SharkSpec.stub_asset_service
    SharkSpec.stub_contact_service
    SharkSpec.stub_consent_service
    SharkSpec.stub_subscription_service
  end
end
