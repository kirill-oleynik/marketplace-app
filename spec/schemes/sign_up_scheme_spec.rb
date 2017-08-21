require 'rails_helper'

RSpec.describe 'SignUpScheme' do
  let(:subject) { SignUpScheme.call(params) }
  let(:valid_params) do
    attributes_for(:user).merge(
      password: '123456',
      password_confirmation: '123456'
    )
  end

  describe 'first_name validation' do
    include_examples 'user_name validation', :first_name
  end

  describe 'last_name validation' do
    include_examples 'user_name validation', :last_name
  end

  describe 'password validation' do
    include_examples 'password validation'
  end

  describe 'email validation' do
    include_examples 'email validation'
  end
end
