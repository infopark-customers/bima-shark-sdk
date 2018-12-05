require "spec_helper"

RSpec.describe Shark::DoubleOptInService::Request do
  let(:request_attributes) do
    {
      request_type: "registration",
      recipient: "john.doe@example.org",
      message: "Thank you for your registration! Please verify your e-mail address to complete your registration.",
      verification_url: "https://client.example.org/verification?foo=bar#baz",
      verification_link_text: "Click me to verify!",
      subject: "Please verify your e-mail address",
      payload: "Foo Bar Baz",
      timeout: 24.hours.seconds.to_i,
      max_verifications: 1
    }
  end

  describe ".create" do
    subject { described_class.create(request_attributes) }
    it { expect(subject).to be_a(described_class) }

    it do
      p Shark::RSpec::FakeDoubleOptInService::ObjectCache.instance.add_execution({ foo: "bar" })
    end
  end
end
