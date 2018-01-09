require File.expand_path("../../shark/rspec/helpers", __FILE__)

RSpec.configure do |config|
  # config.include Shark::RSpec::Helpers
end

module SharkSpec
  extend Shark::RSpec::Helpers
end
