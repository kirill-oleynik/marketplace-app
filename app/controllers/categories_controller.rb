class CategoriesController < ApiController
  def index
    result = ViewCategoriesListInteraction.new.call
    respond_with(result, status: 200, each_serializer: CategorySerializer)
  end
end
