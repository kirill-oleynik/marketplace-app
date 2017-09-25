class CreateApplicationCandidateInteraction
  include Dry::Transaction
  include Inject[
    scheme: 'schemes.create_application_candidate',
    repository: 'repositories.application_candidate'
  ]

  step :validate
  step :persist

  def validate(params)
    result = scheme.call(params)

    if result.success?
      Right(params)
    else
      Left([:invalid, result.errors])
    end
  end

  def persist(params)
    record = repository.create!(params)

    Right(record)
  end
end
