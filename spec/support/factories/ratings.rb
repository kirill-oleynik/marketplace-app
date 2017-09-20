FactoryGirl.define do
  factory :rating do
    application

    trait :zero do
      average 0
      one_points_votes 0
      two_points_votes 0
      three_points_votes 0
      four_points_votes 0
      five_points_votes 0
    end

    factory :zero_rating, traits: [:zero]
  end
end
