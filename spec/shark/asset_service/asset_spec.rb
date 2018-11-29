require "spec_helper"

RSpec.describe Shark::AssetService::Asset do
  let(:asset_attributes) do
    {
      "filename" => "test.png",
      "directory" => "test-directory"
    }
  end

  describe "allowed actions" do
    describe ".all" do
      subject { described_class.all }

      let!(:assets) do
        [
          described_class.create(asset_attributes),
          described_class.create(asset_attributes)
        ]
      end

      it { is_expected.to be_a(Array) }
      it { expect(subject.map(&:id)).to contain_exactly(*assets.map(&:id)) }
    end

    describe ".create" do
      subject { described_class.create(asset_attributes) }
      it{ expect(subject).to be_a (described_class) }
    end

    describe ".find" do
      subject { described_class.find(id) }

      let!(:asset) { described_class.create(asset_attributes) }
      let(:id) { asset.id }

      it { is_expected.to be_a(Array) }
      it { expect(subject.first).to be_a(described_class) }
      it { expect(subject.first.id).to eq(asset.id) }
    end

    describe "#destroy" do
      subject { asset.destroy }
      let!(:asset) { described_class.create(asset_attributes) }
      it { is_expected.to eq(true) }
    end

    describe "#recreate_variations" do
      subject { asset.recreate_variations }
      let!(:asset) { described_class.create(asset_attributes) }
      it { is_expected.to eq([]) }
    end
  end

  describe "forbidden actions" do
    describe ".where" do
      subject { described_class.where(id: "14sh-shal213") }
      it { expect{ subject }.to raise_error(Shark::ActionNotSupportedError) }
    end
  end
end