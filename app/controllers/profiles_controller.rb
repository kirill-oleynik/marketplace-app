class ProfilesController < ApiController
  before_action :authenticate!

  def create
    result = ChangeExtraInfoInteraction.new.call(
      create_params.merge(user_id: current_user.id)
    )

    respond_with(result, status: 201, serializer: ProfileSerializer)
  end

  private

  def create_params
    params.permit(:phone, :job_title, :organization)
  end
end
