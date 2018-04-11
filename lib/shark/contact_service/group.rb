module Shark
  module ContactService
    class Group < Base
      has_many :contacts

      def has_contact?(contact_id)
        relationships["contacts"]["data"].any? { |c| c["type"] == "contacts" && c["id"].to_s == contact_id.to_s }
      end
    end
  end
end
