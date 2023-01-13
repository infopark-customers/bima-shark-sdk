# frozen_string_literal: true

require 'shark/mailing_service/base'
require 'shark/mailing_service/mail'

module Shark
  module MailingService
    class << self
      def use_shark_mailer
        require 'shark/mailing_service/configuration'
        require 'shark/mailing_service/renderers/context'
        require 'shark/mailing_service/renderers/erb_renderer'
        require 'shark/mailing_service/mailer'

        yield(config)
      end

      def config
        @config ||= Configuration.new
      end
    end
  end
end
