require "spec_helper"

RSpec.describe Shark::ContactService::Contact do
  let(:contact_attributes) { { first_name: "John", last_name: "Doe", email: "john.doe@example.org" } }

  describe ".find" do
    subject { described_class.find(id) }

    context "when contact ID exists" do
      let!(:contact) { described_class.create(contact_attributes) }
      let(:id) { contact.id }

      it { is_expected.to be_a(Array) }
      it { expect(subject.first).to be_a(described_class) }
      it { expect(subject.first.id).to eq(contact.id) }
    end

    context "when contact ID is unknown" do
      let(:id) { "unknown-contact-id" }
      it { expect{ subject }.to raise_error(Shark::ResourceNotFound) }
    end
  end

  describe ".find_by_email" do
    subject { described_class.find_by_email(email) }

    context "with correct email address" do
      let(:email) { "foo.bar@example.org" }

      let!(:contacts) do
        [
          Shark::ContactService::Contact.create(contact_attributes),
          Shark::ContactService::Contact.create(first_name: "Foo", last_name: "Bar", email: email)
        ]
      end

      it { expect(subject).to be_a(JsonApiClient::Query::Builder) }
      it { expect(subject.all.length).to eq(1) }
      it { expect(subject.first).to be_a(Shark::ContactService::Contact) }
      it { expect(subject.first.id).to eq(contacts.second.id) }
    end

    context "with incorrect email address" do
      let(:email) { "not-existing-email@example.org" }
      it { expect(subject.first).to eq(nil) }
    end
  end

  describe "#account" do
    subject { contact.account }

    context "when contact has account" do
      let!(:account) { Shark::ContactService::Account.create(name: "Account") }
      let!(:contact) { described_class.create(contact_attributes.merge(account_id: account.id)) }
      it { is_expected.to be_a(Shark::ContactService::Account) }
    end

    context "when contact has no account" do
      let!(:existing_contact) { described_class.create(contact_attributes) }
      let(:contact) { described_class.find(existing_contact.id).first }
      it { is_expected.to eq(nil) }
    end
  end
end
