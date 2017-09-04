FactoryGirl.define do
  factory :session do
    skip_create

    client_id { Faker::Number.number(10) }
    access_token { Faker::Lorem.characters(10) }
    refresh_token { Faker::Lorem.characters(10) }
  end
end
