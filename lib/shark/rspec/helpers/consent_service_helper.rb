module Shark
  module RSpec
    module Helpers
      module ConsentServiceHelper
        def stub_consent_service
          FakeConsentService.setup
        end
      end
    end
  end
end
