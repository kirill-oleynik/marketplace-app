require 'rails_helper'

RSpec.describe SessionRepository do
  subject { described_class.new(redis: redis) }

  let(:redis) do
    redis = double('redis')
    allow(redis).to receive_messages(
      sadd: true, hmset: true, expire: true, del: true, srem: true
    )
    redis
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

    it 'sends right message to redis' do
      expect(redis)
        .to receive(:sadd).with('user_sess:user_id', 'sess:id')
      expect(redis)
        .to receive(:hmset).with('sess:id', data)
      expect(redis)
        .to receive(:expire).with('sess:id', lifetime)

      subject.persist(
        session_id: id,
        data: data,
        lifetime: lifetime
      )
    end
  end

  describe '#session_key' do
    it 'returns formatted key with given id' do
      expect(subject.session_key('id')).to eq('sess:id')
    end
  end

  describe '#delete' do
    let(:user_id) { 1 }
    let(:session_id) { '12345' }

    it 'deletes session and removes it from user sessions' do
      session_key = subject.session_key(session_id)
      user_sessions_key = subject.user_key(user_id)

      expect(redis).to receive(:del).with(session_key)
      expect(redis).to receive(:srem).with(user_sessions_key, session_key)

      subject.delete(user_id: user_id, session_id: session_id)
    end
  end

  describe '#user_key' do
    it 'returns formatted key with given id' do
      expect(subject.user_key('id')).to eq('user_sess:id')
    end
  end

  describe '#delete_sessions' do
    let(:user_id) { '123' }
    let(:except_ids) { %w[111 222] }

    before(:each) do
      allow(redis)
        .to receive(:smembers)
        .with('user_sess:123')
        .and_return(%w[sess:111 sess:222 sess:333 sess:444])
    end

    it 'deletes session keys for given user considering exceptions' do
      expect(redis).not_to receive(:del).with('sess:111')
      expect(redis).not_to receive(:del).with('sess:222')
      expect(redis).to receive(:del).with('sess:333')
      expect(redis).to receive(:del).with('sess:444')

      expect(redis)
        .not_to receive(:srem).with('user_sess:123', %w[sess:111 sess:222])
      expect(redis)
        .to receive(:srem).with('user_sess:123', %w[sess:333 sess:444])

      subject.delete_sessions(
        user_id: user_id,
        exclude_sessions_ids: except_ids
      )
    end
  end

  describe '#exists?' do
    let(:user_id) { '111' }
    let(:client_id) { '222' }

    before(:each) do
      allow(redis)
        .to receive(:smembers)
        .with('user_sess:111')
        .and_return(session_keys)
    end

    context 'when session exists for given user' do
      let(:session_keys) { %w[sess:111 sess:222] }

      it 'returns true' do
        result = subject.exists?(user_id: user_id, session_id: client_id)
        expect(result).to be_truthy
      end
    end

    context 'when session doesn not exist for given user' do
      let(:session_keys) { %w[sess:111] }

      it 'returns false' do
        result = subject.exists?(user_id: user_id, session_id: client_id)
        expect(result).to be_falsey
      end
    end
  end

  describe '#find' do
    let(:client_id) { '111' }
    let(:redis_response) { 'redis_response' }

    before(:each) do
      allow(redis)
        .to receive(:hgetall)
        .with('sess:111')
        .and_return(redis_response)
    end

    it 'sends to client hgetall with session key and returns it response' do
      expect(subject.find(client_id)).to eq(redis_response)
    end
  end
end
