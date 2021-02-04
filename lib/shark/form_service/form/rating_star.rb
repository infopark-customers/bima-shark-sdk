# frozen_string_literal: true

module Shark
  module FormService
    module Form
      class RatingStar < Element
        def values
          element['valid_values']
        end
      end
    end
  end
end
