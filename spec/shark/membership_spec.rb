# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Shark::Membership do
  let!(:contact) { Shark::Contact.create }
  let!(:group) do
    group = Shark::Group.create(title: 'Existing group with contact')
    group.relationships['contacts'] = [contact]
    group.save
    group
  end

  describe '.exists?' do
    let(:group_id) { group.id }
    subject { described_class.exists?(group_id: group_id, contact_id: contact_id) }

    context 'when membership exists' do
      let(:contact_id) { contact.id }

      it { is_expected.to eq(true) }
    end

    context 'when no membership' do
      let(:contact_id) { 'unknown-id' }

      it { is_expected.to eq(false) }
    end
  end
end
