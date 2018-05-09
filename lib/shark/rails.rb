module Shark
  if Object.const_defined?(:Rails) and Rails.const_defined?(:Railtie)
    class Railtie < Rails::Railtie
      initializer "bima_shark_sdk.initialize" do |_|
        Shark.configure do |config|
          config.logger = ::Rails.logger
        end
      end
    end
  end
end
