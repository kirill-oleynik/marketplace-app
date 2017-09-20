class ViewApplicationGalleryInteraction
  include Dry::Transaction
  include Inject[
    gallery_repository: 'repositories.gallery',
    application_repository: 'repositories.application'
  ]

  step :find_application
  step :find_gallery

  def find_application(application_slug)
    application = application_repository.find_by_slug!(application_slug)

    Right(application.id)
  rescue ActiveRecord::RecordNotFound
    Left([:not_found, { id: application_slug, entity: 'application' }])
  end

  def find_gallery(application_id)
    gallery = gallery_repository.find_by_application_id!(application_id)

    Right(gallery)
  rescue ActiveRecord::RecordNotFound
    Right(
      Gallery::Null.new(application_id: application_id)
    )
  end
end
