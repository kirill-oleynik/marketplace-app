module ApplicationSerializer
  class Full < Base
    attributes :description, :website, :email, :address, :phone, :founded,
               :categories_ids

    has_one :favorite
    has_one :review

    def favorite
      return unless scope.current_user

      Favorite.find_by_user_and_application(
        application: object,
        user: scope.current_user
      )
    end

    def review
      return unless scope.current_user

      review = Review.find_by_user_and_application(
        application: object,
        user: scope.current_user
      )

      review.try(:value) || 0
    end
  end
end
