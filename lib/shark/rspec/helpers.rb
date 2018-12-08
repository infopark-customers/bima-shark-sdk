require_relative "fake_asset_service"
require_relative "fake_contact_service"
require_relative "fake_notification_service"
require_relative "fake_consent_service"
require_relative "fake_subscription_service"
require_relative "fake_double_opt_in_service"

require_relative "helpers/fixtures"
require_relative "helpers/response"
require_relative "helpers/asset_service_helper"
require_relative "helpers/contact_service_helper"
require_relative "helpers/form_service_helper"
require_relative "helpers/notification_service_helper"
require_relative "helpers/consent_service_helper"
require_relative "helpers/subscription_service_helper"
require_relative "helpers/double_opt_in_service_helper"


module Shark
  module RSpec
    module Helpers
      include Helpers::Fixtures
      include Helpers::Response
      include Helpers::AssetServiceHelper
      include Helpers::ContactServiceHelper
      include Helpers::FormServiceHelper
      include Helpers::NotificationServiceHelper
      include Helpers::ConsentServiceHelper
      include Helpers::SubscriptionServiceHelper
      include Helpers::DoubleOptInServiceHelper
    end
  end
end
