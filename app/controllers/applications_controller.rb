class ApplicationsController < ApiController
  def show
    result = ViewApplicationInteraction.new.call(params[:id])

    respond_with(result, status: 200,
                         scope: serialization_scope,
                         serializer: ApplicationSerializer::Full)
  end
end
