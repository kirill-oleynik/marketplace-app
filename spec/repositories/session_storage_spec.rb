require 'rails_helper'

RSpec.describe SessionStorage do
  subject { described_class.new(storage_client) }
  let(:storage_client) { double(sadd: true, hmset: true, expire: true) }

  describe '#persist' do
    let(:id) { 'id' }
    let(:data) do
      {
        user_id: 'user_id',
        remember_me: true,
        refresh_token_hash: 'refresh_token_hash'
      }
    end
    let(:lifetime) { 100 }

    it 'sends right message to storage_client' do
      expect(storage_client)
        .to receive(:sadd).with('user_sess:user_id', 'sess:id')
      expect(storage_client)
        .to receive(:hmset).with('sess:id', data)
      expect(storage_client)
        .to receive(:expire).with('sess:id', lifetime)

      subject.persist(id, data, lifetime)
    end
  end

  describe '#session_key' do
    it 'returns formatted key with given id' do
      expect(subject.session_key('id')).to eq('sess:id')
    end
  end

  describe '#user_key' do
    it 'returns formatted key with given id' do
      expect(subject.user_key('id')).to eq('user_sess:id')
    end
  end
end
