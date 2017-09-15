class CreateApplicationAttachmentInteraction
  include Dry::Transaction
  include Inject[
    scheme: 'schemes.create_attachment',
    repository: 'repositories.attachment'
  ]

  step :validate
  step :determine_size
  step :determine_original_filename
  step :determine_content_type
  step :persist

  def validate(data)
    result = scheme.call(data)

    if result.success?
      Right(result.output)
    else
      Left([:invalid, result.errors])
    end
  end

  def determine_size(params)
    size = params[:file].size

    Right(
      params.merge(size: size)
    )
  end

  def determine_original_filename(params)
    original_filename = File.basename(params[:file].path)

    Right(
      params.merge(original_filename: original_filename)
    )
  end

  def determine_content_type(params)
    # TODO:
    # Use something else to determine content type,
    # when this interaction will be used not in seeds
    # and validate it here
    content_type = MIME::Types.type_for(
      params[:original_filename]
    ).first.content_type

    Right(
      params.merge(content_type: content_type)
    )
  end

  def persist(params)
    filename = params.delete(:file)

    attachment = repository.create!(
      params.merge(filename: filename)
    )

    Right(attachment)
  end
end
