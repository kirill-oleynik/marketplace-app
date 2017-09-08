require 'rails_helper'

RSpec.describe UpdateUserInteraction do
  subject do
    UpdateUserInteraction.new(
      change_email: change_email,
      update_user_scheme: update_user_scheme,
      persist_profile_command: persist_profile_command
    ).call(params)
  end

  let(:params) { user_params.merge(profile_params).merge(user: user) }

  let(:user_params) { attributes_for(:user) }

  let(:profile_params) { attributes_for(:profile) }

  let(:change_email) { -> (_) { double(success?: true) } }

  let(:update_user_scheme) { -> (_) { double(success?: true) } }

  let(:persist_profile_command) { double(call: 'profile') }

  let(:user) { double('user', update: true, id: 1) }

  describe 'when params valid' do
    it 'returns right monad' do
      expect(subject).to be_right
      expect(subject.value).to eq(user)
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
