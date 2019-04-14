# frozen_string_literal: true

require 'erb'

module Shark
  module MailingService
    module Renderers
      class ErbRenderer
        attr_reader :template_folder

        def initialize(template_folder)
          @template_folder = template_folder
        end

        def render(layout, format, locals = {})
          template = load_template(layout, format)
          context = Context.new(locals)
          engine = ::ERB.new(template)
          engine.result(context.binding)
        end

        protected

        def load_template(template, format, language = 'de')
          path = ::File.join(
            template_folder,
            "#{template}.#{language}.#{format}.erb"
          )
          ::File.read(path)
        end
      end
    end
  end
end
