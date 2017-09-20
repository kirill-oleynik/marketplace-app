class ApplicationsController < ApiController
  def show
    result = ViewApplicationInteraction.new.call(params[:slug])

    respond_with(result, status: 200,
                         scope: serialization_scope,
                         serializer: ApplicationSerializer::Full)
  end
end
