module Shark
  module FormService
    class Structure < FormService::Base
      belongs_to :form
    end
  end
end
