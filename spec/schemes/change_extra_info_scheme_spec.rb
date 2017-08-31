require 'rails_helper'

RSpec.describe ChangeExtraInfoScheme do
  let(:subject) { ChangeExtraInfoScheme.call(params) }
  let(:valid_params) { attributes_for(:profile).merge(user_id: 1) }

  describe 'user_id validation' do
    include_examples 'user id validation'
  end

  describe 'phone validation' do
    include_examples 'phone validation'
  end

  describe 'job_title validation' do
    include_examples 'job title validation'
  end

  describe 'organization validation' do
    include_examples 'organization validation'
  end
end
