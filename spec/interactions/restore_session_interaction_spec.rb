require 'rails_helper'

RSpec.describe RestoreSessionInteraction do
  subject(:result) do
    RestoreSessionInteraction.new(
      jwt: jwt,
      repository: repository,
      restore_session_scheme: restore_session_scheme
    ).call(params)
  end

  let!(:user) { create(:user) }

  let(:jwt) do
    double('jwt', decode: {
      user_id: user.id,
      exp: Time.now.to_i + 1000
    })
  end

  let(:repository) { double('repository', find: user) }

  let(:restore_session_scheme) do
    -> (_) { restore_session_scheme_result }
  end

  let(:restore_session_scheme_result) do
    double('restore_session_scheme_result', success?: true)
  end

  let(:params) { { 'x-auth-token' => 'token' } }

  describe 'when given params are valid' do
    it 'returns Right monad with user', :with_db_cleaner do
      expect(result).to be_right
      expect(result.value).to eq(user)
    end
  end

  describe 'token is not given' do
    let(:params) { {} }

    let(:restore_session_scheme_result) do
      double('restore_session_scheme_result', success?: false, errors: 'errors')
    end

    it 'returns Left monad with invalid errors', :with_db_cleaner do
      expect(result).to be_left
      expect(result.value[0]).to eq(:invalid)
    end
  end

  describe 'when token is expired' do
    let(:jwt) do
      jwt = double('jwt')
      allow(jwt).to receive(:decode).and_raise(JWT::ExpiredSignature)
      jwt
    end

    it 'returns Left monad with unauthorized error', :with_db_cleaner do
      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  describe 'when user not found' do
    let(:repository) do
      repository = double('repository')

      allow(repository)
        .to receive(:find)
        .and_raise(ActiveRecord::RecordNotFound)

      repository
    end

    it 'returns Left monad with unauthorized error' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end
end
