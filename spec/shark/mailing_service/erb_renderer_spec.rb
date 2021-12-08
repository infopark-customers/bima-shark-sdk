# frozen_string_literal: true

require 'spec_helper'

Shark::MailingService.use_shark_mailer do |mailer|
  mailer.default_layout = 'system_2019'
end

RSpec.describe Shark::MailingService::Renderers::ErbRenderer do
  let(:renderer) { described_class.new(template_folder) }
  let(:template_folder) { 'spec/templates' }

  describe '#render' do
    let(:layout) { 'html' }
    let(:template) { 'test' }
    let(:locals) { { foo: 'foobar' } }

    it 'renders template and partial' do
      body = renderer.render(template, layout, locals)

      expect(body).to include('foo: foobar')
      expect(body).to include('bar: bar123')
    end
  end
end
