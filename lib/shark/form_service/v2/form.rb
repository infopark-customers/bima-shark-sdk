module Shark
  module FormService
    module V2
      class Form < V2::Base

        # @example
        #   form = Shark::FormService::V2::Form.find(id)
        #   form.activate
        #
        # @api public
        def activate
          self.update(state: "active")
        end
      end
    end
  end
end
