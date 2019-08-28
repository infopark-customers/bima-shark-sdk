# frozen_string_literal: true

require 'active_support/all'

require File.expand_path('../shark/rspec/helpers', __dir__)

class SharkSpec
  extend Shark::RSpec::Helpers

  class << self
    def method_missing(method, *args, &block)
      if method.match(/^stub_/)
        fake_service(method).setup
      elsif method.match(/^unstub_/)
        fake_service(method).reset
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
