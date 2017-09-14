require 'rails_helper'

RSpec.describe Category, type: :model do
  it { is_expected.to have_many(:application_categories) }
  it do
    is_expected.to have_many(:applications).through(:application_categories)
  end

  describe '#applications_count' do
    let(:category) { create(:category_with_application) }

    it 'returns amount of related applications', :with_db_cleaner do
      expect(category.applications_count).to eq(1)
    end
  end
end
