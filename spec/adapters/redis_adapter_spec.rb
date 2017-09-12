require 'rails_helper'

RSpec.describe RedisAdapter, :with_redis_cleaner do
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
      redis_connection.set('key', 'value')
      expect(subject.exists('key')).to be_truthy
    end
  end

  describe '#get' do
    it 'returns value if given key exists' do
      redis_connection.set('key', 'value')
      expect(subject.get('key')).to eq('value')
    end

    it 'returns nil if given key not exists' do
      expect(subject.get('undefined')).to be_nil
    end
  end

  describe '#hmset' do
    it 'stores key with hash' do
      subject.hmset('key', foo: :bar)
      expect(redis_connection.hget('key', 'foo')).to eq('bar')
    end
  end

  describe '#hgetall' do
    it 'returns hash by key' do
      redis_connection.hmset('key', 'foo', 'bar', 'baz', 'qux')

      expect(subject.hgetall('key')).to eq(
        'foo' => 'bar',
        'baz' => 'qux'
      )
    end
  end

  describe '#sadd' do
    it 'stores given set' do
      subject.sadd('key', 'item1', 'item2')
      expect(redis_connection.smembers('key')).to match_array(%w[item1 item2])
    end
  end

  describe '#del' do
    it 'deletes given key' do
      redis_connection.set('key', 'value')

      expect(redis_connection.get('key')).to eq('value')
      subject.del('key')
      expect(redis_connection.get('key')).to eq(nil)
    end

    it 'deletes given keys' do
      redis_connection.set('key1', 'value1')
      redis_connection.set('key2', 'value2')

      expect(redis_connection.get('key1')).to eq('value1')
      expect(redis_connection.get('key2')).to eq('value2')
      subject.del('key1', 'key2')
      expect(redis_connection.get('key1')).to eq(nil)
      expect(redis_connection.get('key2')).to eq(nil)
    end
  end

  describe '#srem' do
    it 'removes given value from set' do
      redis_connection.sadd('key', %w[value1 value2])

      expect(redis_connection.smembers('key')).to match_array(%w[value1 value2])
      subject.srem('key', 'value1')
      expect(redis_connection.smembers('key')).to match_array(['value2'])
    end
  end

  describe '#smembers' do
    it 'returns all members of set' do
      redis_connection.sadd('key', %w[value1 value2])

      expect(subject.smembers('key')).to match_array(%w[value1 value2])
    end
  end
end
