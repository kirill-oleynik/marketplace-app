CreateReviewScheme = Dry::Validation.Schema do
  configure do
    def review_value?(value)
      Review::REVIEW_SCALE.include? Integer(value)
    rescue ArgumentError
      false
    end
  end

  required(:user).filled
  required(:application_id) { int? | str? }
  required(:value) { int? | str? & review_value? }
end
