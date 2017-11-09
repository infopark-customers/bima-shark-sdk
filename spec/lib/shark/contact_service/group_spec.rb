require "spec_helper"

RSpec.describe Shark::ContactService::Group do
  describe ".create" do
    subject { described_class.create(attributes) }
    let(:attributes) { { title: "New group" } }
    it { is_expected.to be_a(described_class) }
  end

  describe ".find" do
    subject { described_class.find(id) }
    let!(:group) { described_class.create(title: "Existing group") }
    let(:id) { group.id }

    it { is_expected.to be_a(Array) }
    it { expect(subject.first).to be_a(described_class) }
    it { expect(subject.first.id).to eq(group.id) }
  end
end
