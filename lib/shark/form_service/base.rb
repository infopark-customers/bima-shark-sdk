module Shark
  module FormService
    class Base < ::Shark::Base
      def self.site
        File.join(::Shark.configuration.form_service.site, "/api/v1")
      end
    end
  end
end
