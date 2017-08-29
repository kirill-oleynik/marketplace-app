require 'rails_helper'

RSpec.describe RedisAdapter do
  let(:redis_connection) { Redis.current }

  describe '#set' do
    it 'stores key with value in redis' do
      subject.set('key', 'value')
      expect(redis_connection.get('key')).to eq('value')
    end
  end

  describe '#expire' do
    it 'sets key life time' do
      subject.set('key', 'value')
      subject.expire('key', 10)

      expect(redis_connection.ttl('key')).to be > 0
    end
  end

  describe '#exists' do
    it 'verifies that key exits' do
      subject.set('key', 'value')
      expect(subject.exists('key')).to be_truthy
    end
  end

  describe '#get' do
    it 'returns value if given key exists' do
      subject.set('key', 'value')
      expect(subject.get('key')).to eq('value')
    end

    it 'returns nil if given key not exists' do
      expect(subject.get('undefined')).to be_nil
    end
  end

  after { redis_connection.flushall }
end
