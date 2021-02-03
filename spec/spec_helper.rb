# frozen_string_literal: true

require 'bundler/setup'
require 'pry'
require 'shark'
require 'bima-shark-sdk/rspec'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  Shark.configure do |shark|
    shark.asset_service.site = 'https://asset-service.example.com'
    shark.contact_service.site = 'https://contact-service.example.com'
    shark.form_service.site = 'https://form-service.example.com'
    shark.survey_service.site = 'https://milacrm.example.com'
    shark.notification_service.site = 'https://notification-service.example.com'
    shark.consent_service.site = 'https://consent-service.example.com'
    shark.subscription_service.site = 'https://subscription-service.example.com'
    shark.double_opt_in_service.site = 'https://double-opt-in-service.example.com'
    shark.mailing_service.site = 'https://mailing-service.example.com'
  end

  config.before do
    SharkSpec.stub_asset_service
    SharkSpec.stub_contact_service
    SharkSpec.stub_consent_service
    SharkSpec.stub_double_opt_in_service
    SharkSpec.stub_subscription_service
    SharkSpec.stub_mailing_service
  end
end
