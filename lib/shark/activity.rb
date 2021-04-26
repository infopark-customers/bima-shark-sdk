# frozen_string_literal: true

module Shark
  class Activity < Base
    extend ContactService::Resource

    def self.find_all_by_contact_id(contact_id)
      where(contact_id: contact_id).all
    end
  end
end
