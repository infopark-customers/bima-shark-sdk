require "spec_helper"

RSpec.describe Shark::DoubleOptInService::Execution do
  describe ".verify" do
    subject { described_class.verify(verification_token) }

    context "when token is valid" do
      let!(:verification_token) do
        execution = Shark::RSpec::FakeDoubleOptInService::ObjectCache.instance.add_execution({
          payload: "Foo Bar Baz",
          request_type: "registration"
        })

        execution[:verification_token]
      end
    end
  end
end
