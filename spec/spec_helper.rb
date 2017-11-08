require "bundler/setup"
require "shark"
require "webmock/rspec"

Dir[File.join(File.dirname(__dir__), "spec", "**","*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  # TODO
  # config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # config.before do
  #   FakeContactService.setup
  # end
  #
  # config.after do
  #   FakeContactService.reset
  # end
end
