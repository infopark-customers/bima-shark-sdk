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

        def render(template, format, locals = {})
          template = load_template(template, format)
          context = build_context(format, locals)
          ::ERB.new(template).result(context.binding)
        end

        protected

        def build_context(format, locals)
          context_class = Class.new(Context) do
            if MailingService.config.context_helpers.present?
              MailingService.config.context_helpers.each do |helper|
                include helper
              end
            end
          end

          context = context_class.new(self, locals)
          context.format = format

          context
        end

        def load_template(template, format, language = 'de')
          filename = "#{template}.#{language}.#{format}.erb"
          path = ::File.join(template_folder, filename)
          ::File.read(path)
        end
      end
    end
  end
end
