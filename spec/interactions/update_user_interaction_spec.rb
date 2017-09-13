require 'rails_helper'

RSpec.describe UpdateUserInteraction do
  subject do
    UpdateUserInteraction.new(
      change_email: change_email,
      update_user_scheme: update_user_scheme,
      persist_profile_command: persist_profile_command,
      repository: repository
    )
  end

  let(:params) do
    {
      first_name: 'first_name',
      last_name: 'last_name',
      email: 'old@email.com',
      password: 'old_password',
      phone: '234',
      job_title: 'job_title',
      organization: 'organization',
      user: user
    }
  end

  let(:change_email) do
    change_email = double('change_email')
    allow(change_email)
      .to receive(:call)
      .with(params.slice(:email, :password, :user))
      .and_return(change_email_result)

    change_email
  end

  let(:change_email_result) do
    double('change_email_result', success?: true, value: updated_user)
  end

  let(:update_user_scheme) { -> (_) { double(success?: true) } }

  let(:persist_profile_command) { double(call: 'profile') }

  let(:repository) { double('repository', update!: updated_user) }

  let(:user) { double('user', id: 1) }

  let(:updated_user) { double('updated_user', id: 1, email: 'new@email.com') }

  describe 'when params invalid' do
    let(:update_user_scheme) do
      -> (_) { double(success?: false, errors: 'errors') }
    end

    it 'returns left monad with violations' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:invalid)
      expect(result.value[1]).to eq('errors')
    end
  end

  describe 'when params valid' do
    it 'returns right monad with updated user' do
      result = subject.call(params)

      expect(result).to be_right
      expect(result.value).to eq(updated_user)
    end

    context 'and need to update email' do
      let(:repository) { double('repository', update!: updated_user) }
      let(:expected_params) do
        {
          email: 'old@email.com',
          password: 'old_password',
          user: user
        }
      end

      it 'calls change_email command with right attributes' do
        expect(change_email).to receive(:call).with(expected_params)

        subject.call(params)
      end

      it 'returns user with updated email' do
        result = subject.call(params)

        expect(result.value.email).to eq(updated_user.email)
      end
    end

    context 'and no need to update email' do
      it 'does not call change_email command' do
        expect(change_email).not_to receive(:call)

        subject.call(params.except(:email))
      end
    end

    context 'and need to update user info' do
      it 'sends right message and attributes to user repository' do
        expect(repository).to receive(:update!)
          .with(1, first_name: 'first_name', last_name: 'last_name')

        subject.call(params)
      end
    end

    context 'and no need to update user info' do
      it 'does not send message to user repository' do
        expect(repository).not_to receive(:update!)

        subject.call(params.except(:first_name, :last_name))
      end
    end

    context 'when need to update user profile' do
      let(:expected_params) do
        {
          phone: '234',
          job_title: 'job_title',
          organization: 'organization',
          user_id: 1
        }
      end

      it 'sends right message and attributes to persist profile command' do
        expect(persist_profile_command).to receive(:call).with(expected_params)

        subject.call(params)
      end
    end

    context 'when no need to update user profile' do
      it 'does not send message to update profile command' do
        expect(persist_profile_command).not_to receive(:call)

        subject.call(params.except(:phone, :job_title, :organization))
      end
    end
  end
end
