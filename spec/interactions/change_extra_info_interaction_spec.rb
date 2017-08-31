require 'rails_helper'

RSpec.describe ChangeExtraInfoInteraction do
  let(:user_id) { 1 }
  let(:profile_params) { attributes_for(:profile) }
  let(:params) { profile_params.merge(user_id: user_id) }
  let(:profile) { Profile.new params.merge(id: 1) }

  let(:profile_repository) { double }
  let(:change_extra_info_scheme) { double }

  subject do
    ChangeExtraInfoInteraction.new(
      profile_repository: profile_repository,
      change_extra_info_scheme: change_extra_info_scheme
    )
  end

  describe 'transaction was successful' do
    let(:change_extra_info_scheme) { -> (_) { double(success?: true) } }

    context 'when profile was created' do
      let(:profile_repository) do
        repository = double('profile_repository')
        expect(repository).to receive(:find_by_user_id).with(user_id)
                                                       .and_return(nil)
        expect(repository).to receive(:create!).with(params)
                                               .and_return(profile)

        repository
      end

      it 'returns right monad with profile' do
        result = subject.call(params)

        expect(result).to be_right
        expect(result.value).to eq(profile)
      end
    end

    context 'when profile was updated' do
      let(:profile_repository) do
        repository = double('profile_repository')
        expect(repository).to receive(:find_by_user_id).with(user_id)
                                                       .and_return(profile)
        expect(repository).to receive(:update!).with(profile.id, profile_params)
                                               .and_return(profile)

        repository
      end

      it 'returns right monad with profile' do
        result = subject.call(params)

        expect(result).to be_right
        expect(result.value).to eq(profile)
      end
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
