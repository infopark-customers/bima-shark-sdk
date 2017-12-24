module Shark
  module FormService
    class UserInput < FormService::Base
      belongs_to :form
      belongs_to :structure
    end
  end
end
