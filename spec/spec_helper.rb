require "bundler/setup"
require "shark"
require "webmock/rspec"

Dir[File.join(File.dirname(__dir__), "spec", "support", "**","*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include ContactServiceHelper

  Shark.configure do |config|
    config.contact_service.site = URI.join("https://contact-service.dev", "/api/").to_s
  end

  config.before do
    stub_contact_service
  end
end
