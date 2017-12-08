require "bundler/setup"
require "shark"
require "bima-shark-sdk/rspec"
require "pry"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  Shark.configure do |config|
    config.contact_service.site = URI.join("https://contact-service.example.com", "/api/").to_s
  end

  config.before do
    stub_contact_service
  end
end
