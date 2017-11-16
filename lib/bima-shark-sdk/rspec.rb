require File.expand_path("../../shark/rspec/fake_contact_service/object_cache", __FILE__)
require File.expand_path("../../shark/rspec/fake_contact_service/request", __FILE__)
require File.expand_path("../../shark/rspec/fake_contact_service", __FILE__)
require File.expand_path("../../shark/rspec/contact_service_helper", __FILE__)

RSpec.configure do |config|
  config.include Shark::RSpec::ContactServiceHelper
end
