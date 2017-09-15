require 'rails_helper'

RSpec.describe Application, type: :model do
  it { is_expected.to have_many(:application_categories) }
  it { is_expected.to have_many(:categories).through(:application_categories) }
  it { is_expected.to have_one(:application_attachment) }
  it { is_expected.to have_one(:attachment).through(:application_attachment) }

  describe '#find_by_slug!', :with_db_cleaner do
    let!(:application) { create(:application, slug: 'slug') }

    context 'when record exists' do
      it 'returns record' do
        expect(described_class.find_by_slug!('slug')).to eq(application)
      end
    end

    context 'when record does not exist' do
      it 'raises NotFound error' do
        expect { described_class.find_by_slug!('invalid') }
          .to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end