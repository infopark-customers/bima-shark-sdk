module Shark
  module ContactService
    class Group < Base
      has_many :contacts
    end
  end
end
