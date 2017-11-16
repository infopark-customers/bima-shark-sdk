Dir[File.join(File.dirname(__dir__), "..", "spec", "support", "**","*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include ContactServiceHelper
end
