require 'rails_helper'

RSpec.describe RestoreSessionScheme do
  subject { RestoreSessionScheme.call(params) }

  describe 'x-auth-token validation' do
    include_examples 'x-auth-token validation'
  end

  describe 'when all params are valid' do
    let(:params) do
      { 'x-auth-token' => 'token' }
    end

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end
end
