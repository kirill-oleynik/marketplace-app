require 'rails_helper'

RSpec.describe PasswordRecovery::InitializeScheme do
  subject { PasswordRecovery::InitializeScheme.call(params) }
  let(:valid_params) { { email: attributes_for(:user)[:email] } }

  describe 'when all params valid' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  context 'when params are invalid' do
    describe 'email validation' do
      include_examples 'email validation'
    end
  end
end
