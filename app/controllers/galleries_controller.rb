class GalleriesController < ApiController
  def show
    result = ViewApplicationGalleryInteraction.new.call(
      params[:application_slug]
    )

    respond_with(result, status: 200, serializer: GallerySerializer)
  end
end
