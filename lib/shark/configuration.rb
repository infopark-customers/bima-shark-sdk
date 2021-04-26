# frozen_string_literal: true

module Shark
  module AssetService
    module Resource
      mattr_accessor :site
    end
  end

  module ContactService
    module Resource
      mattr_accessor :site
    end
  end

  module ConsentService
    module Resource
      mattr_accessor :site
    end
  end

  module DoubleOptIn
    class ExceededNumberOfVerificationRequestsError < Error; end
    class RequestedUnverifiedExecutionError < Error; end
    class VerificationExpiredError < Error; end

    module Resource
      mattr_accessor :site
    end
  end

  module NotificationService
    module Resource
      mattr_accessor :site
    end
  end

  module SubscriptionService
    module Resource
      mattr_accessor :site
    end
  end

  module SurveyService
    module Resource
      mattr_accessor :site
    end
  end

  class Configuration
    class Service
      attr_accessor :site
      attr_reader :headers

      def initialize
        @headers = {}
      end

      def headers=(value)
        @headers.merge!(value)
      end
    end

    #
    # Shark Configuration
    #
    attr_accessor :cache, :logger
    attr_reader :contact_service
    attr_reader :consent_service
    attr_reader :double_opt_in
    attr_reader :form_service
    attr_reader :survey_service
    attr_reader :notification_service
    attr_reader :subscription_service
    attr_reader :asset_service
    attr_reader :mailing_service

    def initialize
      @asset_service = AssetService::Resource
      @contact_service = ContactService::Resource
      @consent_service = ConsentService::Resource
      @double_opt_in = DoubleOptIn::Resource
      @form_service = Service.new
      @mailing_service = Service.new
      @notification_service = NotificationService::Resource
      @subscription_service = SubscriptionService::Resource
      @survey_service = SurveyService::Resource
    end
  end
end
