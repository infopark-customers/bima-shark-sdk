# frozen_string_literal: true

module Shark
  module FormService
    class Base < ::Shark::Base
      def self.site
        File.join(::Shark.configuration.form_service.site, '/api')
      end
    end
  end
end
