require 'rails_helper'

RSpec.describe SignOutInteraction do
  let(:user_id) { 1 }
  let(:client_id) { '12345' }

  let(:repository) do
    repository_mock do |mock|
      expect(mock).to receive(:delete)
        .with(user_id: user_id, session_id: client_id)
    end
  end

  subject(:result) do
    SignOutInteraction.new(repository: repository)
  end

  context 'when transaction was successfull' do
    it 'returns right monad' do
      result = subject.call(user_id: user_id, client_id: client_id)

      expect(result).to be_right
      expect(result.value).to eq(:ok)
    end
  end
end
