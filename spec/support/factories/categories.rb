FactoryGirl.define do
  factory :category do
    title { generate(:category_name) }
  end
end
