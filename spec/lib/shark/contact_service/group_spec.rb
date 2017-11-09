require "spec_helper"

RSpec.describe Shark::ContactService::Group do
  describe ".create" do
    subject { described_class.create(attributes) }
    let(:attributes) { { title: "New group" } }
    it { is_expected.to be_a(described_class) }
  end

  describe ".find" do
    subject { described_class.find(id) }

    context "when group ID exists" do
      let!(:group) { described_class.create(title: "Existing group") }
      let(:id) { group.id }

      it { is_expected.to be_a(Array) }
      it { expect(subject.first).to be_a(described_class) }
      it { expect(subject.first.id).to eq(group.id) }
    end

    context "when group ID is unknown" do
      let(:id) { "unknown-group-id" }
      it { is_expected.to be_a(Array) }
      it { expect(subject.first).to eq(nil) }
    end
  end

  describe ".all" do
    subject { described_class.all }

    let!(:groups) do
      [
        described_class.create(title: "First group"),
        described_class.create(title: "Second group")
      ]
    end

    it { is_expected.to be_a(Array) }
    it { expect(subject.map(&:id)).to contain_exactly(*groups.map(&:id)) }
  end

  describe "#update_attributes" do
    subject do
      group = described_class.find(id).first
      group.update_attributes(attributes)
    end

    let!(:group) { described_class.create(title: "Existing group", members_can_admin: false) }
    let(:id) { group.id }
    let(:attributes) { { title: "Modified title" } }

    it { is_expected.to eq(true) }
  end
end
