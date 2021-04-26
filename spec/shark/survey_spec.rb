# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Shark::Survey do
  describe '.find' do
    subject { described_class.find(id) }

    context 'when survey exists' do
      let!(:survey) { described_class.create(title: 'Survey Foo') }
      let(:id) { survey.id }

      it { is_expected.to be_a(described_class) }
      it { expect(subject.id).to eq(survey.id) }
    end

    context 'when survey is unknown' do
      let(:id) { 'unknown-id' }
      it { expect { subject }.to raise_error(Shark::ResourceNotFound) }
    end
  end
end
