module Shark
  module DoubleOptInService
    class Base
      include Connected
      
      def self.site
        ::Shark.configuration.double_opt_in_service.site
      end
    end
  end
end
