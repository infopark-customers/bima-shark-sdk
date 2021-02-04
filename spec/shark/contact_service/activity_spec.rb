# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Shark::ContactService::Activity do
  let!(:activity_attributes) { { title: 'Added event', type_id: 'diary' } }

  describe '.find' do
    subject { described_class.find(id) }

    context 'when contact ID exists' do
      let!(:activity) { described_class.create(activity_attributes) }
      let(:id) { activity.id }

      it { is_expected.to be_a(Array) }
      it { expect(subject.first).to be_a(described_class) }
      it { expect(subject.first.id).to eq(activity.id) }
    end

    context 'when contact ID is unknown' do
      let(:id) { 'unknown-contact-id' }
      it { expect { subject }.to raise_error(Shark::ResourceNotFound) }
    end
  end

  describe '.find_all_by_contact_id' do
    subject { described_class.find_all_by_contact_id(contact_id) }

    let(:contact_attributes) do
      {
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.org'
      }
    end
    let!(:contact) { described_class.create(contact_attributes) }

    context 'with correct email address' do
      let(:contact_id) { contact.id }

      let!(:activities) do
        [
          described_class.create(activity_attributes),
          described_class.create(activity_attributes.merge(contact_ids: [contact.id])),
          described_class.create(activity_attributes.merge(contact_ids: [contact.id, 'sample-id']))
        ]
      end

      it { expect(subject).to be_a(Array) }
      it { expect(subject.length).to eq(2) }
      it { expect(subject.first).to be_a(Shark::ContactService::Activity) }
      it { expect(subject.first.id).to eq(activities.second.id) }
    end

    context 'with incorrect email address' do
      let(:contact_id) { 'not-existing-contact-id' }

      it { expect(subject).to eq([]) }
    end
  end
end
