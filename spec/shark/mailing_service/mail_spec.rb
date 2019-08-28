require 'spec_helper'

RSpec.describe Shark::MailingService::Mail do
  let(:mail_attributes) do
    {
      layout: 'system_2019',
      recipient: 'foo.bar@example.com',
      subject: 'mail subject',
      header: 'mail header',
      html_body: '<table>mail body</table>',
      text_body: 'mail body',
      unsubscribe_url: 'https://you-can-unsubscribe-here',
      attachments: {}
    }
  end

  describe '.create' do
    subject { described_class.create(mail_attributes) }
    it { expect(subject).to be_a(described_class) }
  end
end
