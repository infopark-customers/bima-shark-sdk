module Shark
  module ContactService
    class Activity < Base

      def self.find_all_by_contact_id(contact_id)
        options = { contact_id: contact_id }
        where(options).all
      end

    end
  end
end
