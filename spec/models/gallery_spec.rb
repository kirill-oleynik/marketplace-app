require 'rails_helper'

RSpec.describe Gallery, type: :model do
  it { is_expected.to belong_to(:application) }

  it { is_expected.to have_many(:gallery_attachments) }
  it { is_expected.to have_many(:attachments).through(:gallery_attachments) }

  describe '.find_by_application_id!', :with_db_cleaner do
    context 'when gallery exists' do
      let(:application) { create(:application) }
      let!(:gallery) { create(:gallery, application: application) }

      it 'returns gallery' do
        expect(
          Gallery.find_by_application_id!(application.id)
        ).to eq(gallery)
      end
    end

    context 'when gallery not exists' do
      let!(:application) { create(:application) }

      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          Gallery.find_by_application_id!(application.id)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
