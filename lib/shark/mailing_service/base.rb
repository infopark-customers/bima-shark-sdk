# frozen_string_literal: true

module Shark
  module MailingService
    class Base < ::Shark::Base
      def self.site
        ::Shark.configuration.mailing_service.site
      end
    end
  end
end
