require 'rails_helper'

RSpec.describe RefreshSessionScheme do
  subject { RefreshSessionScheme.call(params) }

  let(:valid_params) do
    {
      client_id: 'client_id',
      refresh_token: 'refresh_token'
    }
  end

  describe 'refresh_token validation' do
    include_examples 'refresh token validation'
  end

  describe 'client_id validation' do
    include_examples 'client id validation'
  end
end
