module Shark
  module FormService
    module Form
      class RatingScale < Element
        def values
          scale_start = element["scale_start"].to_i
          scale_end = element["scale_end"].to_i
          allow_no_information = element["allow_no_information"]

          scale_values = (scale_start..scale_end).to_a
          scale_values << -1  if allow_no_information == true

          scale_values
        end
      end
    end
  end
end
