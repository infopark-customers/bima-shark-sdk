module Shark
  module RSpec
    module Helpers
      module ConsentServiceHelper
        def stub_consent_service
          FakeConsentService.setup
        end

        def unstub_consent_service
          FakeConsentService.reset
        end
      end
    end
  end
end
