module Shark
  module SurveyService
    class Survey < Base
      add_datetime_accessors :starts_at, :ends_at, :created_at, :updated_at

      def add_participant(attributes)
        Participant.create(attributes.merge(survey_id: self.id))
      end
    end
  end
end
