require 'rails_helper'

RSpec.describe ViewApplicationGalleryInteraction do
  let(:application) { build(:application, id: 1) }
  let(:gallery) { build(:gallery, application: application) }

  let(:application_repository) do
    repository_mock do |mock|
      allow(mock).to receive(:find_by_slug!)
        .with(application.slug)
        .and_return(application)
    end
  end

  let(:gallery_repository) do
    repository_mock do |mock|
      allow(mock).to receive(:find_by_application_id!)
        .with(application.id)
        .and_return(gallery)
    end
  end

  subject do
    ViewApplicationGalleryInteraction.new(
      gallery_repository: gallery_repository,
      application_repository: application_repository
    )
  end

  describe 'when transaction was successful' do
    it 'is returns right monad with gallery' do
      result = subject.call(application.slug)

      expect(result).to be_right
      expect(result.value).to eq(gallery)
    end
  end

  describe 'when application not exists' do
    let(:application_repository) do
      repository_mock do |mock|
        allow(mock).to receive(:find_by_slug!)
          .with(application.slug)
          .and_raise(ActiveRecord::RecordNotFound)
      end
    end

    it 'is returns left monad with not found error tuple' do
      result = subject.call(application.slug)

      expect(result).to be_left
      expect(result.value.first).to eq(:not_found)
      expect(result.value.last).to eq(
        id: application.slug,
        entity: 'application'
      )
    end
  end

  describe 'when gallery not exists' do
    let(:gallery_repository) do
      repository_mock do |mock|
        allow(mock).to receive(:find_by_application_id!)
          .with(application.id)
          .and_raise(ActiveRecord::RecordNotFound)
      end
    end

    it 'is returns right monad with null gallery' do
      result = subject.call(application.slug)

      expect(result).to be_right
      expect(result.value).to be_a(Gallery::Null)
    end
  end
end
