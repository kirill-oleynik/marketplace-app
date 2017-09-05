class ChangeExtraInfoInteraction
  include Dry::Transaction
  include Inject[
    update_profile_command: 'commands.update_profile_command',
    change_extra_info_scheme: 'schemes.change_extra_info'
  ]

  step :validate
  step :update_profile

  def validate(params)
    result = change_extra_info_scheme.call(params)

    if result.success?
      Right(params)
    else
      Left([:invalid, result.errors])
    end
  end

  def update_profile(params)
    profile = update_profile_command.call(params).value

    Right(profile)
  end
end
