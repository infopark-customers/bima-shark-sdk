module Shark
  module FormService
    module Form
      class TextField < Element

        def pre_text
          attribute_definition("pre_text")["value"]
        end

        def post_text
          attribute_definition("post_text")["value"]
        end

      end
    end
  end
end
