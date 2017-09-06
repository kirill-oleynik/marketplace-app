FactoryGirl.define do
  sequence :email do |n|
    "#{n}#{Faker::Internet.safe_email}"
  end

  sequence :category_name do |n|
    "#{n}#{Faker::Hipster.word}"
  end
end
