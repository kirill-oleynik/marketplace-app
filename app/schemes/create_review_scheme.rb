CreateReviewScheme = Dry::Validation.Schema do
  configure do
    def review_value?(value)
      value.between?(1, 5)
    end
  end

  required(:user).filled
  required(:application_id).filled(:int?)
  required(:value).filled(:int?, :review_value?)
end
