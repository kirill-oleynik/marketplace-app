class UsersController < ApiController
  def create
    result = SignUpInteraction.new.call(params)
    respond_with(result, status: 201, serializer: UserSerializer)
  end
end
