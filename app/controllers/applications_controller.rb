class ApplicationsController < ApiController
  def show
    result = ViewApplicationInteraction.new.call(params[:id])
    respond_with(result, status: 200, serializer: ApplicationSerializer)
  end
end
