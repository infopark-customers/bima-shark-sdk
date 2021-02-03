# frozen_string_literal: true

module Shark
  module ContactService
    class Contact < Base
      include Shark::NormalizedEmail

      custom_endpoint :avatar, on: :collection, request_method: :get

      property :account_id

      has_many :memberships
      has_many :groups

      def self.find_by_email(email)
        normalized_email = normalize_email(email)
        options = { filter: { equals: { email: normalized_email } } }
        where(options).first
      end

      def account
        return nil if account_id.blank?

        begin
          Shark::ContactService::Account.find(account_id).first
        rescue StandardError
          nil
        end
      end
    end
  end
end
