require 'active_support/all'
require 'bima-http'
require 'json_api_client'

require 'shark/client/connection'
require 'shark/middleware/status'

require 'shark/base'

require 'shark/survey_service/base'
require 'shark/survey_service/configuration'
require 'shark/survey_service/participant'
require 'shark/survey_service/participation_key'
require 'shark/survey_service/survey'

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
end
