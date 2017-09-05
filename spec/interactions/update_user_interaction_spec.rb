require 'rails_helper'

RSpec.describe UpdateUserInteraction do
  subject do
    UpdateUserInteraction.new(
      change_email: change_email,
      update_user_scheme: update_user_scheme,
      update_profile_command: update_profile_command,
      user_repository: user_repository
    ).call(params)
  end

  let(:params) { user_params.merge(profile_params) }

  let(:user_params) { attributes_for(:user) }

  let(:profile_params) { attributes_for(:profile) }

  let(:change_email) { -> (_) { double(success?: true) } }

  let(:update_user_scheme) { -> (_) { double(success?: true) } }

  let(:update_profile_command) { double(call: 'profile') }

  let(:user_repository) { double(find: user) }

  let(:user) { double('user', update: true) }

  describe 'when params valid' do
    context 'when user not exists' do
      let(:user_repository) do
        mock = double
        expect(mock).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        mock
      end

      it 'returns left monad with violations' do
        expect(subject).to be_left
        expect(subject.value[0]).to eq(:not_found)
      end
    end

    context 'when user exists' do
      it 'returns right monad' do
        expect(subject).to be_right
        expect(subject.value).to eq(user)
      end
    end

    context 'when given password does not match to user password' do
      let(:change_email) do
        -> (_) { double(success?: false, value: [:invalid, 'errors']) }
      end

      it 'returns left monad with violations' do
        expect(subject).to be_left
        expect(subject.value[0]).to eq(:invalid)
        expect(subject.value[1]).to eq('errors')
      end
    end
  end

  describe 'when params invalid' do
    let(:update_user_scheme) do
      -> (_) { double(success?: false, errors: 'errors') }
    end

    it 'returns left monad with violations' do
      expect(subject).to be_left
      expect(subject.value[0]).to eq(:invalid)
      expect(subject.value[1]).to eq('errors')
    end
  end
end
