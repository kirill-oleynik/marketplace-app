FactoryGirl.define do
  factory :application_candidate do
    url { Faker::Internet.domain_name }
    description { Faker::Lorem.paragraph }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { generate(:email) }
    user
  end
end
