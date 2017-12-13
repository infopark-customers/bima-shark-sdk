require "logger"
require "forwardable"
require "active_support/all"
require "bima-http"
require "json_api_client"

require "shark/version"
require "shark/configuration"
require "shark/error"
require "shark/client/connection"
require "shark/middleware/status"
require "shark/base"

require "shark/form_service/base"
require "shark/form_service/form"
require "shark/form_service/structure"
require "shark/form_service/user_input"

require "shark/survey_service/base"
require "shark/survey_service/participant"
require "shark/survey_service/survey"

require "shark/contact_service/concerns/normalized_email"
require "shark/contact_service/base"
require "shark/contact_service/group"
require "shark/contact_service/account"
require "shark/contact_service/contact"

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
