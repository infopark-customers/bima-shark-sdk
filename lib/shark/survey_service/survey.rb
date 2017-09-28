module Shark
  module SurveyService
    class Survey < Base

      def add_participant(attributes)
        Participant.create(attributes.merge(survey_id: self.id))
      end
    end
  end
end
