# frozen_string_literal: true

module Shark
  class Consent < Base
    extend ContactService::Resource

    belongs_to :contact

    def update_attributes(_attributes = {})
      raise Shark::ActionNotSupportedError,
            'Shark::Consent#update_attributes is not supported'
    end

    def destroy
      raise Shark::ActionNotSupportedError,
            'Shark::Consent#destroy is not supported'
    end

    def save
      if self['id'].present?
        raise Shark::ActionNotSupportedError,
              'Shark::Consent#save is not supported for persisted consents'
      else
        super
      end
    end
  end
end
