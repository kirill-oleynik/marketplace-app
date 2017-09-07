RSpec.shared_examples 'password_confirmation validation' do
  context 'when confirmation password missing' do
    let(:params) { valid_params.except(:password_confirmation) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when confirmation password does not match password' do
    let(:params) do
      valid_params.merge(
        password_confirmation: "invalid_#{valid_params[:password]}"
      )
    end

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end
end
