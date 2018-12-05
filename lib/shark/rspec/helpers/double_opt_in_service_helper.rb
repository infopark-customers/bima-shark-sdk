module Shark
  module RSpec
    module Helpers
      module DoubleOptInServiceHelper
        def stub_double_opt_in_service
          FakeDoubleOptInService.setup
        end

        def unstub_double_opt_in_service
          FakeDoubleOptInService.reset
        end
      end
    end
  end
end
