require_relative "fake_asset_service/object_cache"
require_relative "fake_asset_service/request"

module Shark
  module RSpec
    module FakeAssetService
      def self.setup
        ObjectCache.clear
        Request.setup
      end

      def self.reset
        ObjectCache.clear
      end
    end
  end
end