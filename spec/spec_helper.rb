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
    shark.asset_service.site = 'https://asset.service.com'
    shark.contact_service.site = 'https://contact.service.com/api'
    shark.double_opt_in.site = 'https://double.opt.in.com'
    shark.form_service.site = 'https://form-service.example.com'
    shark.survey_service.site = 'https://milacrm.example.com/api/v1/projects'
    shark.notification_service.site = 'https://notification.service.com'
    shark.mailing_service.site = 'https://mailing-service.example.com'
  end

  config.before do
    SharkSpec.stub_asset_service
    SharkSpec.stub_contact_service
    SharkSpec.stub_double_opt_in
    SharkSpec.stub_mailing_service
    SharkSpec.stub_survey_service
  end
end
