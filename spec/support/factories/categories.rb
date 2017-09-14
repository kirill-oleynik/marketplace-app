FactoryGirl.define do
  factory :category do
    title { generate(:category_name) }

    factory :category_with_application do
      after(:create) do |category|
        application = build(:application)
        application.categories << category
        application.save
      end
    end
  end
end
