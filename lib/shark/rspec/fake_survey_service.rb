# frozen_string_literal: true

require_relative 'fake_survey_service/object_cache'
require_relative 'fake_survey_service/request'

module Shark
  module RSpec
    module FakeSurveyService
      def self.setup
        ObjectCache.clear
        Request.setup
      end

      def self.reset
        ObjectCache.clear
      end
    end
  end
end
