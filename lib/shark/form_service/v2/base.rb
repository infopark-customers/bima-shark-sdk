module Shark
  module FormService
    module V2
      class Base < FormService::Base
        def self.site
          File.join(::Shark.configuration.form_service.site, "/api/v2")
        end
      end
    end
  end
end

