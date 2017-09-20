FactoryGirl.define do
  factory :review do
    value { rand(1..5) }
    user
    application
  end
end
