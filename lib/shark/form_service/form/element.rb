module Shark
  module FormService
    module Form
      class Element
        attr_reader :parent, :children

        def initialize(element, parent = nil)
          @element = element.except("elements") || {}
          @parent = parent
          @children = parse_children(element["elements"] || [])
        end

        def id
          @element["id"]
        end

        def label
          return ""  unless attribute_defined?("legend")
          attribute_definition("legend")["value"]
        end

        def type
          @element["type"]
        end

        def text
          return ""  unless attribute_defined?("text")
          attribute_definition("text")["value"]
        end

        def attribute_definitions
          @element["attribute_definitions"] || []
        end

        def attribute_definition(name)
          attribute_definitions.detect { |a| a["name"] == name }
        end

        def attribute_defined?(name)
          attribute_definition(name).present?
        end

        def ancestors
          return parent.ancestors << self  if parent.present?
          [self]
        end


        protected
        def element
          @element
        end

        def parse_children(elements)
          elements.map do |e|
            case e["type"]
            when "form_container"
              Container.new(e, self)
            when "form_multiple_choice"
              MultipleChoice.new(e, self)
            when "form_rating_scale"
              RatingScale.new(e, self)
            when "form_textarea"
              TextArea.new(e, self)
            else
              raise ArgumentError, "Unknown form element type: #{e["type"]}"
            end
          end
        end
      end
    end
  end
end
