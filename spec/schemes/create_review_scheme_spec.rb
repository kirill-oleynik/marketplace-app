require 'rails_helper'

RSpec.describe CreateReviewScheme do
  subject { described_class.call(params).success? }

  let(:valid_params) do
    {
      application_id: 1,
      user: build(:user),
      value: 1
    }
  end

  context 'when all params are valid' do
    let(:params) { valid_params }

    it { is_expected.to be_truthy }
  end

  describe 'application_id' do
    context 'when value is missing' do
      let(:params) { valid_params.except(:application_id) }

      it { is_expected.to be_falsey }
    end
  end

  describe 'user' do
    context 'when value is missing' do
      let(:params) { valid_params.except(:user) }

      it { is_expected.to be_falsey }
    end
  end

  describe 'value' do
    context 'when value is missing' do
      let(:params) { valid_params.except(:application_id) }

      it { is_expected.to be_falsey }
    end

    context 'when string does not contain a number between 1 and 5' do
      let(:params) { valid_params.merge(value: 0) }

      it { is_expected.to be_falsey }
    end
  end
end
