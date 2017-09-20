class RatingsController < ApiController
  def show
    result = ViewRatingInteraction.new.call(params[:application_slug])
    respond_with(result, status: 200, serializer: RatingSerializer)
  end
end
