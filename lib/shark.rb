require "active_support/all"
require "rack"
require "faraday"
require "json_api_client"

require "shark/version"
require "shark/configuration"
require "shark/error"
require "shark/middleware/compose_request"
require "shark/middleware/status"
require "shark/client/connection"
require "shark/concerns/normalized_email"

require "shark/base"
require "shark/contact_service"
require "shark/form_service"
require "shark/survey_service"
require "shark/notification_service"

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
  self.configure do |config|
    config.cache = ActiveSupport::Cache::NullStore.new
    config.logger = ::Logger.new("/dev/null")
    config.logger.formatter = proc do |severity, datetime, progname, msg|
      "#{severity}, #{msg}\n"
    end
  end
end

require "shark/rails"
