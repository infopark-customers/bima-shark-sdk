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
          context = build_context(locals)
          engine = ::ERB.new(template)
          engine.result(context.binding)
        end

        protected

        def build_context(locals)
          context_class = Class.new(Context) do
            if MailingService.config.context_helpers.present?
              MailingService.config.context_helpers.each do |helper|
                include helper
              end
            end
          end
          context_class.new(locals)
        end

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
