FactoryGirl.define do
  sequence :email do |n|
    "#{n}#{Faker::Internet.safe_email}"
  end
end
