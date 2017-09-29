class SearchController < ApiController
  def index
    result = SearchInteraction.new.call(index_params)

    respond_with(result, status: 200,
                         include: '**',
                         serializer: SearchResultSerializer)
  end

  private

  def index_params
    params.permit(:query)
  end
end
