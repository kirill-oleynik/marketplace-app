require 'rails_helper'

RSpec.describe 'Categories requests' do
  describe '#show' do
    context 'when category exists', :with_db_cleaner do
      let!(:category) { create(:category) }

      it 'returns single category' do
        get category_path(category.id)

        expect(response).to have_http_status(200)
        expect(response.body).to match_response_schema('category')
        expect(
          JSON.parse(response.body)['data']['id']
        ).to eq(category.id)
      end
    end

    context 'when category not exists' do
      it 'returns not found error' do
        get category_path(1)

        expect(response).to have_http_status(404)
        expect(response.body).to match_response_schema('errors/base')
      end
    end
  end

  describe '#index', :with_db_cleaner do
    let!(:category) { create(:category) }

    it 'returns list of categories' do
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
