# frozen_string_literal: true

module Shark
  module AssetService
    class Base < ::Shark::Base
      def self.site
        ::Shark.configuration.asset_service.site
      end
    end
  end
end
