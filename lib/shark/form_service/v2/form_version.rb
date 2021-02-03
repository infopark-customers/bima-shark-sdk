# frozen_string_literal: true

module Shark
  module FormService
    module V2
      class FormVersion < V2::Base
        belongs_to :form

        def self.table_name
          'versions'
        end

        def form_structure
          @form_structure ||= FormService::Form::Structure.new(structure)
        end
      end
    end
  end
end
