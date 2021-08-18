# frozen_string_literal: true

require 'active_support/all'
require 'rack'
require 'faraday'
require 'json_api_client'

require 'shark/version'
require 'shark/error'
require 'shark/configuration'
require 'shark/middleware/compose_request'
require 'shark/middleware/status'
require 'shark/client/connection'

require 'shark/concerns/normalized_email'
require 'shark/concerns/connected'

module Shark
  extend SingleForwardable

  def_single_delegators :configuration, :cache, :logger

  mattr_accessor :configuration

  def self.configure
    self.configuration ||= Configuration.new
    yield self.configuration
  end

  # Within the given block, add the service token authorization header to all api requests.
  #
  # @param token [String] The service token for the authorization header
  # @param block [Block] The block where service token authorization will be set for
  # @api public
  def self.with_service_token(token)
    if token.is_a?(String)
      self.service_token = token
    elsif token.respond_to?(:jwt)
      self.service_token = token.jwt
    else
      raise ArgumentError, 'Parameter :token must be kind of String.'
    end

    yield
  ensure
    self.service_token = nil
  end

  # @api public
  def self.service_token
    Thread.current['shark-service-token']
  end

  # @api private
  def self.service_token=(value)
    Thread.current['shark-service-token'] = value
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

require 'shark/base'
require 'shark/asset'
require 'shark/account'
require 'shark/activity'
require 'shark/consent'
require 'shark/contact'
require 'shark/double_opt_in/execution'
require 'shark/double_opt_in/request'
require 'shark/group'
require 'shark/membership'
require 'shark/notification'
require 'shark/package'
require 'shark/permission'
require 'shark/subscription'
require 'shark/survey'
require 'shark/survey_participant'

require 'shark/form_service'
require 'shark/mailing_service'

require 'shark/rails'
