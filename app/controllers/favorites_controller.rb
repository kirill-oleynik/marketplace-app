class FavoritesController < ApiController
  before_action :authenticate!

  def index
    result = ViewFavoritesListInteraction.new.call(current_user)
    respond_with result, status: 200, each_serializer: FavoriteSerializer::Full
  end

  def create
    result = AddToFavoritesInteraction.new.call(
      user: current_user,
      application_id: params[:application_id]
    )

    respond_with result, status: 201, serializer: FavoriteSerializer::Short
  end

  def destroy
    result = RemoveFromFavoritesInteraction.new.call(
      id: params[:id],
      user: current_user
    )

    respond_with result, status: 200, serializer: FavoriteSerializer::Short
  end
end
