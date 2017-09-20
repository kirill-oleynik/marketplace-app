class ReviewsController < ApiController
  before_action :authenticate!

  def create
    result = CreateReviewInteraction.new.call(create_params)
    respond_with(result, status: 200, serializer: ReviewSerializer)
  end

  private

  def create_params
    params.permit(:application_id, :value).merge(user: current_user)
  end
end
