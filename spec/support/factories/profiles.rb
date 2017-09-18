FactoryGirl.define do
  factory :profile do
    phone { Faker::Number.number(10).to_s }
    job_title { Faker::Lorem.characters(10) }
    organization { Faker::Lorem.characters(10) }
  end
end
