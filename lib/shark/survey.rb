# frozen_string_literal: true

module Shark
  class Survey < Base
    extend SurveyService::Resource

    add_datetime_accessors :starts_at, :ends_at, :created_at, :updated_at

    def self.find(*args)
      super.first
    end

    def add_participant(attributes)
      SurveyParticipant.create(attributes.merge(survey_id: id))
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
