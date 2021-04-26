# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Shark::SurveyParticipant do
  let(:attributes) do
    { survey_id: 'some-survey-id', state: '' }
  end

  describe '.create' do
    subject { described_class.create(attributes) }

    it { is_expected.to be_a(described_class) }
  end

  describe '.find' do
    subject { described_class.find(id) }

    context 'when participant exists' do
      let!(:participant) { described_class.create(attributes) }
      let(:id) { participant.id }

      it { is_expected.to be_a(described_class) }
      it { expect(subject.id).to eq(participant.id) }
    end

    context 'when participant is unknown' do
      let(:id) { 'unknown-id' }
      it { expect { subject }.to raise_error(Shark::ResourceNotFound) }
    end
  end
end
