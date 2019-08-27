require File.expand_path('../../shark/rspec/helpers', __FILE__)

RSpec.configure do |config|

end

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
      service = method.to_s.gsub(/(un)?stub_/, '')
      service = camelize(service)
      Module.const_get("Shark::RSpec::Fake#{service}")
    end

    def camelize(string, delimiter = '_')
      string.split(delimiter).map(&:capitalize).join
    end
  end
end
