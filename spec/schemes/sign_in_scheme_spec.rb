require 'rails_helper'

RSpec.describe SignInScheme do
  subject { SignInScheme.call(params) }

  let(:valid_params) do
    {
      email: attributes_for(:user)[:email],
      password: SecureRandom.hex(5)
    }
  end

  describe 'password validation' do
    include_examples 'password validation'
  end

  describe 'email validation' do
    include_examples 'email validation'
  end
end
