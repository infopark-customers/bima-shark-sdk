# frozen_string_literal: true

module Shark
  module ContactService
    class Base < ::Shark::Base
      def self.site
        File.join(::Shark.configuration.contact_service.site, '/api')
      end
    end
  end
end
