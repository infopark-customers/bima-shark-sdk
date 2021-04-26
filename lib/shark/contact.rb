# frozen_string_literal: true

module Shark
  class Contact < Base
    extend ContactService::Resource
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

      Shark::Account.find(account_id).first
    end
  end
end
