require 'rails_helper'

RSpec.describe SignUpInteraction do
  let(:params) do
    attributes_for(:user).merge(
      password: '123456',
      password_confirmation: '123456'
    )
  end

  let(:scheme_result) do
    double('scheme_result', success?: true)
  end

  let(:scheme) do
    -> (_) { scheme_result }
  end

  let(:bcrypt) do
    double('bcrypt', encode: 'hashed_password')
  end

  let(:repository) do
    mock = double('repository')

    def mock.create!(attributes)
      User.new(attributes)
    end

    mock
  end

  subject do
    SignUpInteraction.new(
      scheme: scheme,
      bcrypt: bcrypt,
      repository: repository
    )
  end

  describe 'when transaction was successful' do
    it 'is returns right monad with created user' do
      result = subject.call(params)

      expect(result).to be_right
      expect(result.value.first_name).to eq(params[:first_name])
      expect(result.value.last_name).to eq(params[:last_name])
      expect(result.value.email).to eq(params[:email])
      expect(result.value.password_hash).to eq('hashed_password')
    end
  end

  describe 'when validation failed' do
    let(:scheme_result) do
      double('scheme_result', success?: false, errors: 'Ooops!')
    end

    it 'is returns left monad with validation error tuple' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:invalid)
      expect(result.value[1]).to eq('Ooops!')
    end
  end

  describe 'when email already taken' do
    let(:repository) do
      mock = double('repository')

      expect(mock).to receive(:create!).and_raise(
        ActiveRecord::RecordNotUnique
      ).once

      mock
    end

    it 'is returns left monad with validation error tuple' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:invalid)
      expect(result.value[1][:email]).to eq([I18n.t('errors.not_unique')])
    end
  end
end
