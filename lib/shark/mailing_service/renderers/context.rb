# frozen_string_literal: true

module Shark
  module MailingService
    module Renderers
      class Context
        extend Forwardable

        attr_writer :format

        def_delegator :I18n, :t

        def initialize(renderer, locals = {})
          @locals = locals.symbolize_keys
          @renderer = renderer
        end

        def binding
          super
        end

        def render(template, locals = {})
          @renderer.render(template, @format, locals)
        end

        protected

        def method_missing(name, *args, &block)
          return super unless respond_to?(name)

          @locals[name]
        end

        def respond_to_missing?(name, _include_all)
          @locals.keys.include?(name.to_sym)
        end
      end
    end
  end
end
