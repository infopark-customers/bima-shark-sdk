# frozen_string_literal: true

module Shark
  class Group < Base
    extend ContactService::Resource

    has_many :contacts

    def contact?(contact_id)
      contacts = relationships['contacts']
      return false if contacts.blank? || contacts['data'].blank?

      contacts['data'].any? { |c| c['type'] == 'contacts' && c['id'].to_s == contact_id.to_s }
    end

    alias has_contact? contact?
  end
end
