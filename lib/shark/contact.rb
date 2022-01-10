# frozen_string_literal: true

module Shark
  class Contact < Base
    extend ContactService::Resource
    include Shark::NormalizedEmail

    custom_endpoint :avatar, on: :collection, request_method: :get

    property :account_id

    has_many :memberships
    has_many :groups
    has_one :permission

    def self.find_by_email(email)
      normalized_email = normalize_email(email)
      options = { filter: { equals: { email: normalized_email } } }
      where(options).first
    end

    # @example
    #   contacts = Shark::ContactService::Contact.find_by_permissions([
    #     { resource: 'paragraph::contract', privilege: 'admin' },
    #     { resource: 'datenraum', privilege: 'admin'}
    #   ])
    #
    # @param permissions_filter [Array] the filter of resources and privileges.
    # @api public
    def self.find_by_permissions(permissions_filter)
      includes('permission').where(permissions: permissions_filter)
    end

    def account
      return nil if account_id.blank?

      Shark::Account.find(account_id).first
    end

    def consents
      Shark::Consent.where(contact_id: id)
    end

    def create_contract(params)
      Shark::Contract.create(params.merge(contact_id: id))
    end
  end
end
