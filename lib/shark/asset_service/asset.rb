module Shark
  module AssetService
    class Asset < Base
      custom_endpoint :recreate_variations, on: :member, request_method: :post

      def self.where(args = {})
        raise Shark::ActionNotSupportedError, "Shark::AssetService::Asset.where is not supported"
      end
    end
  end
end
