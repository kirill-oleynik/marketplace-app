FactoryGirl.define do
  factory :profile do
    phone { Faker::Number.number(10) }
    job_title { Faker::Lorem.characters(10) }
    organization { Faker::Lorem.characters(10) }
  end
end
