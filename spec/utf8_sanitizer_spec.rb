require 'utf8_sanitizer'
# require 'utf8'
require 'spec_helper'

RSpec.describe 'Utf8Sanitizer' do
  it 'has a version number' do
    expect(Utf8Sanitizer::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(true).to eq(true)
  end
end
