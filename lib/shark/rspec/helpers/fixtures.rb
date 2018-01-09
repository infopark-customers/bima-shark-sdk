module Shark
  module RSpec
    module Helpers
      module Fixtures
        def form_structure_json
          load_json_fixture("form_structure.json")
        end

        def form_inputs_json
          load_json_fixture("form_inputs.json")
        end

        def load_json_fixture(filename)
          JSON.parse(load_fixture(filename))
        end

        def load_fixture(filename)
          filepath = File.expand_path("../../fixtures/#{filename}", __FILE__)
          File.read(filepath)
        end
      end
    end
  end
end

