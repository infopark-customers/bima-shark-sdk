# frozen_string_literal: true

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
      attachments: {},
      from: 'sender@example.com',
      header_image: 'some-image',
      reply_to: 'no-reply@example.com',
      unsubscribe_url: 'https://you-can-unsubscribe-here'
    }
  end

  describe '.create' do
    subject { described_class.create(mail_attributes) }
    it { expect(subject).to be_a(described_class) }
  end
end
