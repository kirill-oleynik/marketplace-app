class CreateApplicationInteraction
  include Dry::Transaction
  include Inject[
    scheme: 'schemes.create_application',
    application_repository: 'repositories.application',
    application_attachment_repository: 'repositories.application_attachment'
  ]

  step :validate
  step :persist

  def validate(data)
    result = scheme.call(data)

    if result.success?
      Right(result.output)
    else
      Left([:invalid, result.errors])
    end
  end

  def persist(params)
    application = application_repository.transaction do
      app = application_repository.create!(
        params.except(:attachment_id)
      )

      application_attachment_repository.create!(
        application_id: app.id,
        attachment_id: params[:attachment_id]
      )

      app
    end

    Right(application)
  rescue ActiveRecord::RecordNotUnique
    Left([:invalid, slug: [I18n.t('errors.not_unique')]])
  end
end
