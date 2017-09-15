require 'rails_helper'

RSpec.describe 'Applications requests' do
  describe '#show' do
    context 'when application exists', :with_db_cleaner do
      let!(:application) { create(:application) }

      it 'returns single application' do
        get application_path(application.slug)

        expect(response).to have_http_status(200)
        expect(response.body).to match_response_schema('application')
        expect(
          JSON.parse(response.body)['data']['id']
        ).to eq(application.id)
      end
    end

    context 'when application not exists' do
      it 'returns not found error' do
        get application_path(1)

        expect(response).to have_http_status(404)
        expect(response.body).to match_response_schema('errors/base')
      end
    end
  end
end
