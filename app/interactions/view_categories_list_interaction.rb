class ViewCategoriesListInteraction
  include Dry::Transaction
  include Inject[
    repository: 'repositories.category'
  ]

  step :find

  def find
    categories = repository.all

    Right(categories)
  end
end
