class ViewApplicationInteraction
  include Dry::Transaction
  include Inject[
    repository: 'repositories.application'
  ]

  step :find

  def find(slug)
    application = repository.find_by_slug!(slug)

    Right(application)
  rescue ActiveRecord::RecordNotFound
    Left([:not_found, { id: slug, entity: 'application' }])
  end
end
