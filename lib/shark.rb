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
  def self.with_service_token(token, &block)
    if token.is_a?(String)
      auth_token = "Bearer #{token}"
    elsif token.respond_to?(:jwt)
      auth_token = "Bearer #{token.jwt}"
    else
      raise ArgumentError, 'Parameter :token must be kind of String.'
    end

    with_auth_token(auth_token, &block)
  end

  # Within the given block, add the authorization header token to all api requests.
  #
  # @param token [String] The token for the authorization header
  # @param block [Block] The block where authorization token will be set for
  # @api public
  def self.with_auth_token(token)
    raise ArgumentError, 'Parameter :token must be kind of String.' unless token.is_a?(String)

    self.auth_token = token

    yield
  ensure
    self.auth_token = nil
  end

  # @api public
  def self.auth_token
    Thread.current['shark-auth-token']
  end

  # @api private
  def self.auth_token=(value)
    Thread.current['shark-auth-token'] = value
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
require 'shark/contract'
require 'shark/double_opt_in/execution'
require 'shark/double_opt_in/request'
require 'shark/group'
require 'shark/membership'
require 'shark/notification'
require 'shark/package'
require 'shark/permission'
require 'shark/survey'
require 'shark/survey_participant'
require 'shark/contact_log'

require 'shark/form_service'
require 'shark/mailing_service'

require 'shark/rails'
