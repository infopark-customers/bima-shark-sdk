module Shark
  module RSpec
    module Helpers
      module AssetServiceHelper
        def stub_asset_service
          FakeAssetService.setup
        end

        def unstub_asset_service
          FakeAssetService.reset
        end
      end
    end
  end
end
