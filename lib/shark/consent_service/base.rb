# frozen_string_literal: true

module Shark
  module ConsentService
    class Base < ::Shark::Base
      def self.site
        ::Shark.configuration.consent_service.site
      end
    end
  end
end
