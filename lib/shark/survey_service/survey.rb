# frozen_string_literal: true

module Shark
  module SurveyService
    class Survey < Base
      add_datetime_accessors :starts_at, :ends_at, :created_at, :updated_at

      def add_participant(attributes)
        Participant.create(attributes.merge(survey_id: id))
      end

      def scheduled?
        flags.present? && flags.include?('scheduled')
      end

      def running?
        flags.present? && flags.include?('running')
      end

      def closed?
        flags.present? && flags.include?('closed')
      end
    end
  end
end
