require 'rails_helper'

RSpec.describe 'SignUpScheme' do
  let(:subject) { SignUpScheme }
  let(:params) do
    attributes_for(:user).merge(
      password: '123456',
      password_confirmation: '123456'
    )
  end

  describe 'first_name validation' do
    it 'is invalid when value missing' do
      expect(
        subject.call(params.merge(first_name: nil)).success?
      ).to be_falsey
    end

    it 'is invalid with value not string' do
      expect(
        subject.call(params.merge(first_name: 123456)).success?
      ).to be_falsey
    end

    it 'is invalid when value not filled' do
      expect(
        subject.call(params.merge(first_name: '')).success?
      ).to be_falsey
    end
  end

  describe 'last_name validation' do
    it 'is invalid when value missing' do
      expect(
        subject.call(params.merge(last_name: nil)).success?
      ).to be_falsey
    end

    it 'is invalid with value not string' do
      expect(
        subject.call(params.merge(last_name: 123456)).success?
      ).to be_falsey
    end

    it 'is invalid when value not filled' do
      expect(
        subject.call(params.merge(last_name: '')).success?
      ).to be_falsey
    end
  end

  describe 'email validation' do
    it 'is invalid when value missing' do
      expect(
        subject.call(params.merge(email: nil)).success?
      ).to be_falsey
    end

    it 'is invalid with value not string' do
      expect(
        subject.call(params.merge(email: 123456)).success?
      ).to be_falsey
    end

    it 'is invalid when value not filled' do
      expect(
        subject.call(params.merge(email: '')).success?
      ).to be_falsey
    end

    it 'is invalid when value not in email format' do
      expect(
        subject.call(params.merge(email: 'not_an_email')).success?
      ).to be_falsey
    end
  end

  describe 'password validation' do
    it 'is invalid when value missing' do
      expect(
        subject.call(params.merge(password: nil)).success?
      ).to be_falsey
    end

    it 'is invalid with value not string' do
      expect(
        subject.call(params.merge(password: 123456)).success?
      ).to be_falsey
    end

    it 'is invalid when value not filled' do
      expect(
        subject.call(params.merge(password: '')).success?
      ).to be_falsey
    end

    it 'is invalid when value less than 6' do
      expect(
        subject.call(params.merge(password: '1234')).success?
      ).to be_falsey
    end

    it 'is invalid when password_confirmation is missing' do
      expect(
        subject.call(params.merge(password_confirmation: nil)).success?
      ).to be_falsey
    end

    it 'is invalid when password_confirmation not match value' do
      expect(
        subject.call(params.merge(password_confirmation: '654321')).success?
      ).to be_falsey
    end
  end
end
