# frozen_string_literal: true

module Shark
  module ConsentService
    class Consent < Base
      def self.all
        raise Shark::ActionNotSupportedError, 'Shark::ConsentService::Consent.all is not supported'
      end

      def update_attributes(_attributes = {})
        raise Shark::ActionNotSupportedError, 'Shark::ConsentService::Consent#update_attributes is not supported'
      end

      def destroy
        raise Shark::ActionNotSupportedError, 'Shark::ConsentService::Consent#destroy is not supported'
      end

      def save
        if self['id'].present?
          raise Shark::ActionNotSupportedError, 'Shark::ConsentService::Consent#save is not supported for persisted consents'
        else
          super
        end
      end
    end
  end
end
