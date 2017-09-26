require 'rails_helper'

RSpec.describe PasswordRecovery::InitializeScheme do
  subject { PasswordRecovery::InitializeScheme.call(params) }
  let(:valid_params) { { email: attributes_for(:user)[:email] } }

  describe 'email validation' do
    include_examples 'email validation'
  end
end
