class ChangeExtraInfoInteraction
  include Dry::Transaction
  include Inject[
    persist_profile_command: 'commands.persist_profile',
    change_extra_info_scheme: 'schemes.change_extra_info'
  ]

  step :validate
  step :persist

  def validate(params)
    result = change_extra_info_scheme.call(params)

    if result.success?
      Right(params)
    else
      Left([:invalid, result.errors])
    end
  end

  def persist(params)
    profile = persist_profile_command.call(params).value

    Right(profile)
  end
end
