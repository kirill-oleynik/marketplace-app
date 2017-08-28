require 'rails_helper'

RSpec.describe RestoreSessionScheme do
  subject { RestoreSessionScheme.call(params) }

  describe 'password validation' do
    context 'when value is missing' do
      let(:params) { {} }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end

    context 'when value is emtpy string' do
      let(:params) do
        { 'x-auth-token' => '' }
      end

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end

    context 'when value is not a string' do
      let(:params) do
        { 'x-auth-token' => 1234 }
      end

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end

    context 'when value is filled string' do
      let(:params) do
        { 'x-auth-token' => 'token' }
      end

      it 'is valid' do
        expect(subject.success?).to be_truthy
      end
    end
  end
end
