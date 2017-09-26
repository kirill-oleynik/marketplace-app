class ApplicationCandidatesController < ApiController
  before_action :authenticate!

  def create
    result = CreateApplicationCandidateInteraction.new.call(create_attributes)
    respond_with(result, status: 200,
                         serializer: ApplicationCandidateSerializer)
  end

  private

  def create_attributes
    create_params.merge(
      user_first_name: current_user.first_name,
      user_last_name: current_user.last_name,
      user_email: current_user.email,
      user: current_user
    )
  end

  def create_params
    params.permit(:url, :description)
  end
end
