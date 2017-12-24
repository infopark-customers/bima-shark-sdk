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
      it { expect{ subject }.to raise_error(Shark::ResourceNotFound) }
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
    subject { group.update_attributes(attributes) }

    let!(:group) { described_class.create(title: "Existing group") }
    let(:attributes) { { title: "Modified title" } }

    it { is_expected.to eq(true) }
  end

  describe "#destroy" do
    subject { group.destroy }
    let!(:group) { described_class.create(title: "Existing group") }
    it { is_expected.to eq(true) }
  end

  describe "modifying group members" do
    subject do
      group.relationships["contacts"] = contacts
      group.save
    end

    let!(:group) { described_class.create(title: "Existing group") }
    let!(:contacts) { [Shark::ContactService::Contact.create] }

    it { is_expected.to eq(true) }

    it "changes contacts" do
      subject
      fetched_group = described_class.find(group.id).first
      contact_ids = fetched_group.relationships["contacts"]["data"].map { |d| d["id"] }
      expect(contact_ids).to contain_exactly(*contacts.map(&:id))
    end
  end
end
