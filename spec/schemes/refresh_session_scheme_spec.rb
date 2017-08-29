require 'rails_helper'

RSpec.describe RefreshSessionScheme do
  subject { RefreshSessionScheme.call(params) }

  describe 'x-auth-token validation' do
    include_examples 'x-auth-token validation'
  end

  describe 'client-id validation' do
    context 'when value is missing' do
      let(:params) { {} }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end

    context 'when value is emtpy string' do
      let(:params) do
        { 'client-id' => '' }
      end

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end

    context 'when value is not a string' do
      let(:params) do
        { 'client-id' => 1234 }
      end

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end
  end

  describe 'when all params are valid' do
    let(:params) do
      {
        'x-auth-token' => 'token',
        'client-id' => 'client-id'
      }
    end

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end
end
