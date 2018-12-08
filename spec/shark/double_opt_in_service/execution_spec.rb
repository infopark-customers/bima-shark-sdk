require "spec_helper"

RSpec.describe Shark::DoubleOptInService::Execution do  
  let(:payload) { "Foo Bar Baz" }
  let(:request_type) { "registration" }
  let(:max_verifications) { 0 }  # unlimited verification requests

  # execution has never been verified, or, in other words,
  # verification link has never been klicked by recipient
  let(:verifications_count) { 0 }

  let(:verification_expires_at) { Time.now.to_i + 3600 }
  let(:execution_expires_at) { verification_expires_at + 3600 }

  describe ".verify" do
    subject { described_class.verify(verification_token) }

    context "when token exists" do
      let!(:verification_token) do
        execution = Shark::RSpec::FakeDoubleOptInService::ObjectCache.instance.add_execution({
          "payload" => payload,
          "request_type" => request_type,
          "max_verifications" => max_verifications,
          "verifications_count" => verifications_count,
          "verification_expires_at" => verification_expires_at,
          "execution_expires_at" => execution_expires_at
        })

        execution["id"]
      end

      context "when number of maximum verification requests is set to unlimited" do
        let(:max_verifications) { 0 }
        let(:verifications_count) { 3 }
        it { expect(subject).to be_a(described_class) }
      end

      context "when number of limited verification requests is not exceeded" do
        let(:max_verifications) { 1 }
        let(:verifications_count) { 0 }
        it { expect(subject).to be_a(described_class) }
      end

      context "when number of verification requests is exceeded" do
        let(:max_verifications) { 1 }
        let(:verifications_count) { 1 }
        it { expect{ subject }.to raise_error(Shark::DoubleOptInService::ExceededNumberOfVerificationRequestsError) }
      end

      context "when verification time expired" do
        context "when execution time is not expired" do
          let(:verification_expires_at) { Time.now.to_i - 3600 }
          let(:execution_expires_at) { Time.now.to_i + 3600 }
          it { expect{ subject }.to raise_error(Shark::DoubleOptInService::VerificationExpiredError) }
        end

        context "when execution time is expired" do
          let(:verification_expires_at) { Time.now.to_i - 2 * 3600 }
          let(:execution_expires_at) { Time.now.to_i - 3600 }
          it { expect{ subject }.to raise_error(Shark::ResourceNotFound) }
        end
      end
    end

    context "when token does not exist" do
      let(:verification_token) { "not-found" }
      it { expect{ subject }.to raise_error(Shark::ResourceNotFound) }
    end
  end
end
