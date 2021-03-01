# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Shark::Consent do
  let(:consent_attributes) do
    {
      legal_subject_id: 'first-contact-id',
      items: {
        email: {
          active: true,
          editor_id: 'second-contact-id',
          editor_full_name: 'John Doe'
        }
      }
    }
  end

  describe 'allowed actions' do
    describe '.find' do
      subject { described_class.find(id) }

      let!(:consent) { described_class.create(consent_attributes) }
      let(:id) { consent.id }

      it { is_expected.to be_a(Array) }
      it { expect(subject.first).to be_a(described_class) }
      it { expect(subject.first.id).to eq(consent.id) }
    end

    describe '.create' do
      subject { described_class.create(consent_attributes) }
      it { expect(subject).to be_a(described_class) }
    end

    describe '#save' do
      subject { consent.save }
      let(:consent) { described_class.new(consent_attributes) }
      it { expect(subject).to eq(true) }
    end
  end

  describe 'forbidden actions' do
    let!(:consent) { described_class.create(consent_attributes) }

    describe '#destroy' do
      subject { consent.destroy }
      it { expect { subject }.to raise_error(Shark::ActionNotSupportedError) }
    end

    describe '#update_attributes' do
      subject { consent.update_attributes({}) }
      it { expect { subject }.to raise_error(Shark::ActionNotSupportedError) }
    end

    describe '#save' do
      subject { consent.save }
      it { expect { subject }.to raise_error(Shark::ActionNotSupportedError) }
    end

    describe '.all' do
      subject { described_class.all }
      it { expect { subject }.to raise_error(Shark::ActionNotSupportedError) }
    end
  end
end
