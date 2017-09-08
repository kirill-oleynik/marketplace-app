class PersistProfileCommand
  include Dry::Transaction
  include Inject[
    profile_repository: 'repositories.profile'
  ]

  step :find_profile
  step :persist

  def find_profile(params)
    profile = profile_repository.find_by_user_id(params[:user_id])

    Right(
      params.merge(profile_id: profile.try(:id))
    )
  end

  def persist(params)
    profile_id = params[:profile_id]

    profile =
      if profile_id
        profile_repository.update!(
          profile_id, params.slice(:phone, :job_title, :organization)
        )
      else
        profile_repository.create!(
          params.slice(:user_id, :phone, :job_title, :organization)
        )
      end

    Right(profile)
  end
end
