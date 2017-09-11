class ViewCategoryInteraction
  include Dry::Transaction
  include Inject[
    repository: 'repositories.category'
  ]

  step :find

  def find(id)
    category = repository.find(id)

    Right(category)
  rescue ActiveRecord::RecordNotFound
    Left([:not_found, { id: id, entity: 'category' }])
  end
end
