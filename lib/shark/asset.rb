# frozen_string_literal: true

module Shark
  class Asset < Base
    extend AssetService::Resource

    custom_endpoint :recreate_variations, on: :member, request_method: :post

    def self.where(_args = {})
      raise Shark::ActionNotSupportedError, 'Shark::AssetService::Asset.where is not supported'
    end
  end
end
