FactoryGirl.define do
  factory :application_candidate do
    url { Faker::Internet.domain_name }
    description { Faker::Lorem.paragraph }
    user_first_name { Faker::Name.first_name }
    user_last_name { Faker::Name.last_name }
    user_email { generate(:email) }
    user
  end
end
