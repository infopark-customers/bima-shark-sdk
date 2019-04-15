# frozen_string_literal: true

module Shark
  module MailingService
    module Renderers
      class Context
        extend Forwardable

        def_delegator :I18n, :t

        def initialize(locals = {})
          @locals = locals.symbolize_keys
        end

        def binding
          super
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
