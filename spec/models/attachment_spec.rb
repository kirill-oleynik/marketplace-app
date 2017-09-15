require 'rails_helper'

RSpec.describe Attachment, type: :model do
  describe '#url', :with_db_cleaner do
    subject { create(:attachment, :with_file) }

    it 'returns url to file' do
      name = File.basename(subject.filename.path)

      expect(subject.url).to eq(
        "/uploads/test/attachment/#{subject.id}/#{name}"
      )
    end
  end
end
