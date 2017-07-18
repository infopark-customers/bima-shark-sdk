require 'spec_helper'

RSpec.describe Shark do
  it 'has a version number' do
    expect(Shark::VERSION).not_to be_nil
  end
end
