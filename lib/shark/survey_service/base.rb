module Shark
  module SurveyService
    class Base < ::Shark::Base
      def self.find(*args)
        super.first
      end
    end
  end
end
