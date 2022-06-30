# frozen_string_literal: true

module Shark
  module FormService
    module V2
      class Form < V2::Base
        has_many :versions

        # @example
        #   form = Shark::FormService::V2::Form.find(id)
        #   form.activate
        #
        # @api public
        def activate
          update(state: 'active')
        end
      end
    end
  end
end
