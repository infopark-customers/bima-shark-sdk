# frozen_string_literal: true

require 'active_support/all'

require File.expand_path('../shark/rspec/helpers', __dir__)

class SharkSpec
  extend Shark::RSpec::Helpers

  class << self
    def method_missing(name, *args, &block)
      if name.match(/^stub_/)
        fake_service(name).setup
      elsif name.match(/^unstub_/)
        fake_service(name).reset
      else
        super
      end
    end

    def respond_to_missing?(name, _include_private)
      if name.match(/^stub_/)
        true
      elsif name.match(/^unstub_/)
        true
      else
        super
      end
    end

    protected

    def fake_service(method)
      service = method.to_s.gsub(/(un)?stub_/, '').camelize
      Module.const_get("Shark::RSpec::Fake#{service}")
    end
  end
end
