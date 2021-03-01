# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Shark::Subscription do
  let(:subscription_attributes) do
    {
      name: 'marketing-newsletter',
      subscriberId: 'sl123djslfjd132slj23fsdd',
      subscriberType: 'contact',
      consentId: '23sdkld222213ggls433'
    }
  end

  let(:subscriptions_attributes) do
    [
      {
        name: 'notifications',
        subscriberId: 'sl123djslfjd132slj23fsdd',
        subscriberType: 'contact',
        consentId: ''
      },
      {
        name: 'test-subscription',
        subscriberId: 'sl123djslfjd132slj23fsdd',
        subscriberType: 'contact',
        consentId: ''
      }
    ]
  end

  describe 'allowed actions' do
    describe '.all' do
      it do
        described_class.create_multiple(subscriptions_attributes)
        expect(described_class.all.count).to eq(2)
      end
    end

    describe '.where' do
      before do
        described_class.create_multiple(subscriptions_attributes)
      end

      describe 'by name' do
        subject { described_class.where(name: 'notifications') }

        it { expect(subject.count).to eq(1) }
      end

      describe 'by subscriber_id' do
        subject { described_class.where(subscriber_id: 'sl123djslfjd132slj23fsdd') }

        it { expect(subject.count).to eq(2) }
      end

      describe 'by name and subscriber_id' do
        subject do
          described_class.where(
            subscriber_id: 'sl123djslfjd132slj23fsdd',
            name: 'test-subscription'
          )
        end

        it { expect(subject.count).to eq(1) }
      end
    end

    describe '.create' do
      subject { described_class.create(subscription_attributes) }
      it { expect(subject).to be_a(described_class) }
    end

    describe '.create_multiple' do
      subject { described_class.create_multiple(subscriptions_attributes) }
      it { expect(subject).to all(be_an(described_class)) }
    end

    describe '.destroy_multiple' do
      let!(:subscriptions) { described_class.create_multiple(subscriptions_attributes) }

      it do
        expect(described_class.all.count).to eq(2)
        described_class.destroy_multiple(subscriptions.map { |sub| { id: sub.id } })
        expect(described_class.all.count).to eq(0)
      end
    end

    describe '#destroy' do
      let!(:subscription) { described_class.create(subscription_attributes) }

      it do
        expect(described_class.all.count).to eq(1)
        subscription.destroy
        expect(described_class.all.count).to eq(0)
      end
    end
  end

  describe 'forbidden actions' do
    let!(:subscription) { described_class.create(subscription_attributes) }

    describe '#update_attributes' do
      subject { subscription.update_attributes({}) }
      it { expect { subject }.to raise_error(Shark::ActionNotSupportedError) }
    end

    describe '#save' do
      subject { subscription.save }
      it { expect { subject }.to raise_error(Shark::ActionNotSupportedError) }
    end
  end
end
