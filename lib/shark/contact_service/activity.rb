module Shark
  module ContactService
    class Activity < Base

      def self.find_all_by_contact_id(contact_id)
        where(contact_id: contact_id).all
      end

    end
  end
end
