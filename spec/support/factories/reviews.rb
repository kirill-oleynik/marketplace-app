FactoryGirl.define do
  factory :review do
    value { Review::REVIEW_SCALE.sample }
    user
    application
  end
end
