require 'rails_helper'

RSpec.describe SessionStorage do
  subject { described_class.new(storage_client) }
  let(:storage_client) do
    storage_client = double('storage_client')
    allow(storage_client).to receive_messages(
      sadd: true, hmset: true, expire: true, del: true, srem: true
    )
    storage_client
  end

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

  describe '#delete' do
    let(:user_id) { '123' }
    let(:except_ids) { %w[111 222] }

    before(:each) do
      allow(storage_client)
        .to receive(:smembers)
        .with('user_sess:123')
        .and_return(%w[sess:111 sess:222 sess:333 sess:444])
    end

    it 'deletes session keys for given user considering exceptions' do
      expect(storage_client).not_to receive(:del).with('sess:111')
      expect(storage_client).not_to receive(:del).with('sess:222')
      expect(storage_client).to receive(:del).with('sess:333')
      expect(storage_client).to receive(:del).with('sess:444')

      expect(storage_client)
        .not_to receive(:srem).with('user_sess:123', %w[sess:111 sess:222])
      expect(storage_client)
        .to receive(:srem).with('user_sess:123', %w[sess:333 sess:444])

      subject.delete(user_id, except_ids)
    end
  end

  describe '#exists?' do
    let(:user_id) { '111' }
    let(:client_id) { '222' }

    before(:each) do
      allow(storage_client)
        .to receive(:smembers)
        .with('user_sess:111')
        .and_return(session_keys)
    end

    context 'when session exists for given user' do
      let(:session_keys) { %w[sess:111 sess:222] }

      it 'returns true' do
        expect(subject.exists?(user_id, client_id)).to be_truthy
      end
    end

    context 'when session doesn not exist for given user' do
      let(:session_keys) { %w[sess:111] }

      it 'returns false' do
        expect(subject.exists?(user_id, client_id)).to be_falsey
      end
    end
  end
end
