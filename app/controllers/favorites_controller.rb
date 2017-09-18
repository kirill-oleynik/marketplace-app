class FavoritesController < ApiController
  before_action :authenticate!

  def create
    result = AddToFavoritesInteraction.new.call(
      user: current_user,
      application_id: params[:application_id]
    )

    respond_with result, status: 201, serializer: FavoriteSerializer
  end

  def destroy
    result = RemoveFromFavoritesInteraction.new.call(
      id: params[:id],
      user: current_user
    )

    respond_with result, status: 200, serializer: FavoriteSerializer
  end
end
