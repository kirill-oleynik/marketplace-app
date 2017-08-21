require 'rails_helper'

RSpec.describe JwtAdapter do
  describe '#encode' do
    let(:payload) { { sample: 'hash' } }

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
end
