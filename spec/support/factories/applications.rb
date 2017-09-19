FactoryGirl.define do
  factory :application do
    slug { Faker::Internet.slug.tr('.', '') }
    title { Faker::App.name }
    summary { Faker::Lorem.paragraph }
    description { Faker::Lorem.paragraph }
    website { Faker::Internet.domain_name }
    email { generate(:email) }
    phone { Faker::PhoneNumber.cell_phone }
    founded { Faker::Date.between(5.years.ago, Date.yesterday) }
    address do
      "#{Faker::Address.street_address}, "\
      "#{Faker::Address.city}, "\
      "#{Faker::Address.zip}"
    end

    factory :application_with_categories do
      transient do
        categories []
      end

      after(:create) do |application, evaluator|
        application.categories << evaluator.categories
        application.save
      end
    end
  end
end
