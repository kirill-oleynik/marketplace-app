class ApplicationSerializer < ActiveModel::Serializer
  attributes :id, :title, :summary, :description, :website, :email, :address,
             :phone, :founded, :logo, :slug

  has_one :favorite

  def favorite
    return unless scope.current_user

    Favorite.find_by_user_and_application(
      application: object,
      user: scope.current_user
    )
  end
end
