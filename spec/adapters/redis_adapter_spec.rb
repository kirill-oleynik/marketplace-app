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
end
