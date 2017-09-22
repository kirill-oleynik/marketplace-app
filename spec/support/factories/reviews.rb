FactoryGirl.define do
  factory :review do
    value { Review::REVIEW_SCALE.sample }
    user
    rating
  end
end
