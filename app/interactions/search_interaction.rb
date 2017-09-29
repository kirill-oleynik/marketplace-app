class SearchInteraction
  include Dry::Transaction
  include Inject[
    category_repository: 'repositories.category',
    application_repository: 'repositories.application'
  ]

  step :search

  def search(params)
    categories = category_repository.search(query: params[:query]).to_a
    applications = application_repository.search(query: params[:query]).to_a

    Right(
      SearchResult.new(categories: categories, applications: applications)
    )
  end
end
