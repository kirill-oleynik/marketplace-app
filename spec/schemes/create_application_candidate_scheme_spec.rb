require('rails_helper')

RSpec.describe CreateApplicationCandidateScheme do
  subject(:result) { described_class.call(params).success? }

  let(:valid_params) { attributes_for(:application_candidate) }

  describe 'when params are valid' do
    let(:params) { valid_params }
    it { is_expected.to be_truthy }
  end

  describe 'when params are invalid' do
    context 'url is missing' do
      let(:params) { valid_params.except(:url) }
      it { is_expected.to be_falsey }
    end

    context 'url has incorrect format' do
      let(:params) { valid_params.merge(url: '123') }
      it { is_expected.to be_falsey }
    end

    context 'description is missing' do
      let(:params) { valid_params.except(:description) }
      it { is_expected.to be_falsey }
    end

    context 'description has incorrect format' do
      let(:params) { valid_params.merge(description: 123) }
      it { is_expected.to be_falsey }
    end

    context 'user_first_name is missing' do
      let(:params) { valid_params.except(:user_first_name) }
      it { is_expected.to be_falsey }
    end

    context 'user_first_name has incorrect format' do
      let(:params) { valid_params.merge(user_first_name: 123) }
      it { is_expected.to be_falsey }
    end

    context 'user_last_name is missing' do
      let(:params) { valid_params.except(:user_last_name) }
      it { is_expected.to be_falsey }
    end

    context 'user_last_name has incorrect format' do
      let(:params) { valid_params.merge(user_last_name: 123) }
      it { is_expected.to be_falsey }
    end

    context 'user_email is missing' do
      let(:params) { valid_params.except(:user_email) }
      it { is_expected.to be_falsey }
    end

    context 'user_email has incorrect format' do
      let(:params) { valid_params.merge(user_email: 123) }
      it { is_expected.to be_falsey }
    end
  end
end
