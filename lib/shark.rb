# frozen_string_literal: true

require 'active_support/all'
require 'rack'
require 'faraday'
require 'json_api_client'

require 'shark/version'
require 'shark/configuration'
require 'shark/error'
require 'shark/middleware/compose_request'
require 'shark/middleware/status'
require 'shark/client/connection'

require 'shark/concerns/normalized_email'
require 'shark/concerns/connected'

require 'shark/base'
require 'shark/asset_service'
require 'shark/contact_service'
require 'shark/form_service'
require 'shark/survey_service'
require 'shark/notification_service'
require 'shark/consent_service'
require 'shark/subscription_service'
require 'shark/double_opt_in_service'
require 'shark/mailing_service'

module Shark
  extend SingleForwardable

  def_single_delegators :configuration, :cache, :logger, :with_service_token, :service_token

  mattr_accessor :configuration

  def self.configure
    self.configuration ||= Configuration.new
    yield self.configuration
  end

  #
  # Initial configuration
  #
  configure do |config|
    config.cache = ActiveSupport::Cache::NullStore.new
    config.logger = ::Logger.new('/dev/null')
    config.logger.formatter = proc do |severity, _datetime, _progname, msg|
      "#{severity}, #{msg}\n"
    end
  end
end

require 'shark/rails'
