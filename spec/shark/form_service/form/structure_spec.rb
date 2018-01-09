require "spec_helper"

RSpec.describe Shark::FormService::Form::Structure do
  let(:form_structure) { Shark::FormService::Form::Structure.new(SharkSpec.form_structure_json) }

  describe "#ancestors" do
    it { expect(form_structure.ancestors).to eq [form_structure] }

    context "of a child" do
      it "should return [form_structure, child]" do
        child = form_structure.children.last
        expect(child.ancestors).to eq([form_structure, child])
      end
    end
  end

  describe "#children" do
    it "should return array with 1 element" do
      expect(form_structure.children).to be_kind_of(Array)
      expect(form_structure.children.size).to eq(5)
    end
  end

  describe "#parent" do
    it { expect(form_structure.parent).to be_nil }
  end
end
