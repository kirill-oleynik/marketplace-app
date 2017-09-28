require 'rails_helper'

RSpec.describe JwtAdapter do
  let(:payload) { { sample: 'hash' } }

  describe '#encode' do
    it 'encodes with HS512 algorithm' do
      expect(
        subject.encode(payload)
      ).to match(
        /^eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9./
      )
    end

    it 'encodes given payload' do
      expect(
        subject.encode(payload)
      ).to match(
        /eyJzYW1wbGUiOiJoYXNoIn0./
      )
    end
  end

  describe '#decode' do
    let(:encoded) { subject.encode(payload) }

    it 'returns decoded payload with stringifyed keys' do
      expect(subject.decode(encoded)).to eq(
        [payload.stringify_keys, { 'typ' => 'JWT', 'alg' => 'HS512' }]
      )
    end
  end
end
