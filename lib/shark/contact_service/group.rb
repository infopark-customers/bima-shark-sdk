module Shark
  module ContactService
    class Group < Base
      has_many :contacts

      def has_contact?(contact_id)
        relationships["contacts"]["data"].any? { |c| c["type"] == "contacts" && c["id"] == contact_id }
      end
    end
  end
end
