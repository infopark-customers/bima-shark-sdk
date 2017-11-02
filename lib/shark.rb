require 'active_support/all'
require 'bima-http'
require 'json_api_client'

require 'shark/client/connection'
require 'shark/middleware/status'

require 'shark/base'

require 'shark/form_service/base'
require 'shark/form_service/configuration'
require 'shark/form_service/form'
require 'shark/form_service/structure'
require 'shark/form_service/user_input'

require 'shark/survey_service/base'
require 'shark/survey_service/configuration'
require 'shark/survey_service/participant'
require 'shark/survey_service/survey'

require 'shark/contact_service/base'
require 'shark/contact_service/configuration'
require 'shark/contact_service/group'

require 'shark/configuration'
require 'shark/errors'
require 'shark/version'

module Shark
  mattr_accessor :configuration, :logger

  def self.configure
    self.configuration ||= Configuration.new
    yield self.configuration
  end

  self.logger = ::Logger.new(STDOUT)
  logger.formatter = proc do |_severity, _datetime, _progname, msg|
    "#{msg}\n"
  end

  # @api public
  def self.with_service_token(service_token)
    self._service_token = service_token
    yield
  ensure
    self._service_token = nil
  end

  # @api private
  def self._service_token
    Thread.current["shark-service-token"]
  end

  # @api private
  def self._service_token=(value)
    Thread.current["shark-service-token"] = value
  end
end
