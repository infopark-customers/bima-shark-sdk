# frozen_string_literal: true

require_relative 'fake_asset_service'
require_relative 'fake_contact_service'
require_relative 'fake_notification_service'
require_relative 'fake_consent_service'
require_relative 'fake_subscription_service'
require_relative 'fake_double_opt_in_service'
require_relative 'fake_mailing_service'

require_relative 'helpers/fixtures'
require_relative 'helpers/response'
require_relative 'helpers/form_service_helper'

module Shark
  module RSpec
    module Helpers
      include Helpers::Fixtures
      include Helpers::Response
      include Helpers::FormServiceHelper
    end
  end
end
