# frozen_string_literal: true

module Shark
  module FormService
    module V2
      class FormInput < V2::Base
        belongs_to :form

        def self.table_name
          'inputs'
        end
      end
    end
  end
end
