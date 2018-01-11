require_relative "fake_contact_service"

require_relative "helpers/fixtures"
require_relative "helpers/contact_service_helper"
require_relative "helpers/form_service_helper"


module Shark
  module RSpec
    module Helpers
      include Helpers::Fixtures
      include Helpers::ContactServiceHelper
      include Helpers::FormServiceHelper
    end
  end
end
