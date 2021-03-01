# frozen_string_literal: true

module Shark
  class Membership < Base
    extend ContactService::Resource

    belongs_to :group

    def self.exists?(group_id:, contact_id:)
      where(group_id: group_id, contact_id: contact_id).first
      true
    rescue Shark::ResourceNotFound
      false
    end
  end
end
