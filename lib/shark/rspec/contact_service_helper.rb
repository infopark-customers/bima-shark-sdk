module Shark
  module RSpec
    module ContactServiceHelper
      def stub_contact_service
        FakeContactService.setup
      end

      def unstub_contact_service
        FakeContactService.reset
      end
    end
  end
end
