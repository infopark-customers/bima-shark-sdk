# frozen_string_literal: true

module Shark
  module RSpec
    module FakeAssetService
      module PublicId
        module_function

        def decode_public_id(public_id)
          Base64.urlsafe_decode64(public_id)
        rescue ArgumentError
          nil
        end

        def encode_id(id)
          Base64.urlsafe_encode64(id)
        end
      end
    end
  end
end
