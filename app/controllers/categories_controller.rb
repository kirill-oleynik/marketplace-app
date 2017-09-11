class CategoriesController < ApiController
  def show
    result = ViewCategoryInteraction.new.call(params[:id])

    respond_with result, status: 200,
                         serializer: CategorySerializer::Full
  end

  def index
    result = ViewCategoriesListInteraction.new.call

    respond_with result, status: 200,
                         each_serializer: CategorySerializer::Short
  end
end
