module Shark
  module FormService
    module Form
      class MultipleChoice < Element
        def values
          element["valid_values"]
        end

        def more_on_choice?
          more_on_choice = attribute("more_on_choice")

          return values.include?(more_on_choice["value"])  if more_on_choice.present?
          false
        end
      end
    end
  end
end
