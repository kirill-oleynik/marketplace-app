FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { generate(:email) }
    password_hash { BcryptAdapter.new.encode(SecureRandom.hex(5)) }
  end
end
