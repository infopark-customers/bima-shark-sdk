# frozen_string_literal: true

module Shark
  module SurveyService
    class Participant < Base
      has_one :survey, class_name: '::Shark::SurveyService::Survey'

      def self.create(attributes)
        attributes_copy = attributes.symbolize_keys
        survey_id = attributes_copy.delete(:survey_id)
        raise ArgumentError, 'Missing attribute :survey_id' unless survey_id

        participant = new(attributes_copy)
        participant.relationships.survey = { data: { id: survey_id } }
        participant.save

        participant
      end

      def participated?
        state == 'participated'
      end

      def participate
        update(state: 'participated')
      end
    end
  end
end
