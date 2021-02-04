# frozen_string_literal: true

module Shark
  module RSpec
    module Helpers
      module FormServiceHelper
        def form_version(attributes = {})
          defaults = {
            id: 1,
            state: 'active',
            structure: SharkSpec.form_structure_json
          }

          Shark::FormService::V2::FormVersion.new(defaults.merge(attributes))
        end

        def form_inputs(attributes = {})
          data = SharkSpec.form_inputs_json['data']
          data.map do |input|
            input['attributes'].merge!(attributes)
            Shark::FormService::V2::FormInput.new(input)
          end
        end
      end
    end
  end
end
