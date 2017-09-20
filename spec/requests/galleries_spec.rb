require 'rails_helper'

RSpec.describe 'Galleries requests' do
  describe '#show' do
    context 'when application exists', :with_db_cleaner do
      let(:application) { create(:application) }

      context 'when gallery exists' do
        let!(:gallery) { create(:gallery, application: application) }

        it 'returns application gallery' do
          get application_gallery_path(application.slug)

          expect(response).to have_http_status(200)
          expect(response.body).to match_response_schema('gallery')
          expect(
            JSON.parse(response.body)['data']['id']
          ).to eq(gallery.id)
        end
      end

      context 'when gallery not exists' do
        it 'returns empty gallery' do
          get application_gallery_path(application.slug)

          expect(response).to have_http_status(200)
          expect(response.body).to match_response_schema('gallery')
          expect(
            JSON.parse(response.body)['data']['id']
          ).to eq(nil)
        end
      end
    end

    context 'when application not exists' do
      it 'returns not found error' do
        get application_gallery_path('hello')

        expect(response).to have_http_status(404)
        expect(response.body).to match_response_schema('errors/base')
      end
    end
  end
end
