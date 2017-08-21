require 'rails_helper'

RSpec.describe RedisAdapter do
  before(:each) do
    @redis_server = double(set: :ok, expire: :ok, exists: false)
    allow(Redis).to receive(:new).and_return(@redis_server)
  end

  it 'proxies set message to origin' do
    expect(@redis_server).to receive(:set).with('key', 'value')
    subject.set('key', 'value')
  end

  it 'proxies expire message to origin' do
    expect(@redis_server).to receive(:expire).with('key', 100)
    subject.expire('key', 100)
  end

  it 'proxies exists message to origin' do
    expect(@redis_server).to receive(:exists).with('key')
    subject.exists('key')
  end
end
