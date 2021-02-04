# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Shark::DoubleOptInService::Execution do
  let(:payload) { 'Foo Bar Baz' }
  let(:request_type) { 'registration' }
  let(:max_verifications) { 0 } # unlimited verification requests allowed

  # execution has never been verified, or, in other words,
  # verification link has never been clicked by recipient
  let(:verifications_count) { 0 }

  let(:verification_expires_at) { Time.now.to_i + 3600 }
  let(:execution_expires_at) { verification_expires_at + 3600 }

  let!(:verification_token) do
    cache = Shark::RSpec::FakeDoubleOptInService::ObjectCache.instance
    execution = cache.add_execution({
                                      'payload' => payload,
                                      'request_type' => request_type,
                                      'max_verifications' => max_verifications,
                                      'verifications_count' => verifications_count,
                                      'verification_expires_at' => verification_expires_at,
                                      'execution_expires_at' => execution_expires_at
                                    })

    execution['id']
  end

  shared_examples 'verification_token validation' do
    context 'when token does not exist' do
      let(:verification_token) { 'token-not-found' }
      it { expect { subject }.to raise_error(Shark::ResourceNotFound) }
    end

    context 'when token exists' do
      context 'when execution time is expired' do
        let(:verification_expires_at) { Time.now.to_i - 2 * 3600 }
        let(:execution_expires_at) { Time.now.to_i - 3600 }
        it { expect { subject }.to raise_error(Shark::ResourceNotFound) }
      end

      context 'when execution time is not expired' do
        let(:execution_expires_at) { Time.now.to_i + 3600 }

        context 'when verification time is expired' do
          let(:verification_expires_at) { Time.now.to_i - 3600 }

          context 'when token has never been verified' do
            let(:verifications_count) { 0 }
            it { expect { subject }.to raise_error(Shark::ResourceNotFound) }
          end
        end
      end
    end
  end

  describe '.verify' do
    subject { described_class.verify(verification_token) }

    include_examples 'verification_token validation'

    context 'with unexpired verification time' do
      let(:max_verifications) { 1 }

      context 'when number of limited verification requests is not exceeded' do
        let(:verifications_count) { 0 }
        it { expect(subject).to be_a(described_class) }
      end

      context 'when number of verification requests is exceeded' do
        let(:verifications_count) { 1 }
        let(:error) { Shark::DoubleOptInService::ExceededNumberOfVerificationRequestsError }

        it { expect { subject }.to raise_error(error) }
      end
    end

    context 'with expired verification time' do
      let(:verification_expires_at) { Time.now.to_i - 3600 }

      context 'when execution has been verified before' do
        let(:verifications_count) { 1 }
        let(:error) { Shark::DoubleOptInService::VerificationExpiredError }

        it { expect { subject }.to raise_error(error) }
      end
    end
  end

  describe '.find' do
    subject { described_class.find(verification_token) }

    include_examples 'verification_token validation'

    context 'when token has been verified' do
      let(:verifications_count) { 1 }
      it { expect(subject).to be_a(described_class) }
    end

    context 'when token has not been verified' do
      let(:verifications_count) { 0 }
      let(:expected) { Shark::DoubleOptInService::RequestedUnverifiedExecutionError }
      it { expect { subject }.to raise_error(expected) }
    end
  end

  describe '.terminate' do
    subject { described_class.terminate(verification_token) }
    include_examples 'verification_token validation'
    it { expect(subject).to be_a(described_class) }
  end
end
