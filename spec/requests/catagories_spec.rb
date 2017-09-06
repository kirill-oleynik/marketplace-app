require 'rails_helper'

RSpec.describe 'Categories requests' do
  describe '#index' do
    let!(:category) { create(:category) }

    it 'returns list of categories', :with_db_cleaner do
      expect(Category.count).to eq(1)

      get categories_path

      expect(response).to have_http_status(200)
      expect(response.body).to match_response_schema('categories')
      expect(
        JSON.parse(response.body)['data'].length
      ).to eq(1)
    end
  end
end
