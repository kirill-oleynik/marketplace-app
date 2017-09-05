require 'rails_helper'

RSpec.describe ChangeExtraInfoInteraction do
  let(:user_id) { 1 }
  let(:profile_params) { attributes_for(:profile) }
  let(:params) { profile_params.merge(user_id: user_id) }
  let(:profile) { Profile.new params.merge(id: 1) }

  let(:update_profile_command) { double }
  let(:profile_repository) { double }
  let(:change_extra_info_scheme) { double }

  subject do
    ChangeExtraInfoInteraction.new(
      update_profile_command: update_profile_command,
      change_extra_info_scheme: change_extra_info_scheme
    )
  end

  describe 'transaction was successful' do
    let(:change_extra_info_scheme) { -> (_) { double(success?: true) } }
    let(:update_profile_command) { -> (_) { double(value: profile) } }

    it 'returns right monad with profile' do
      result = subject.call(params)

      expect(result).to be_right
      expect(result.value).to eq(profile)
    end
  end

  describe 'transaction was not successful' do
    context 'when validation failed' do
      let(:change_extra_info_scheme) do
        -> (_) { double(success?: false, errors: 'Oooops!') }
      end

      it 'returns left monad with validation error tuple' do
        result = subject.call(params)

        expect(result).to be_left
        expect(result.value[0]).to eq(:invalid)
        expect(result.value[1]).to eq('Oooops!')
      end
    end
  end
end
