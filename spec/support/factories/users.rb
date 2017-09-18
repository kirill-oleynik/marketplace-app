FactoryGirl.define do
  factory :user do
    transient do
      password SecureRandom.hex(6)
    end

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { generate(:email) }

    after :build do |user, evaluator|
      unless user.password_hash
        user.password_hash = BcryptAdapter.new.encode(evaluator.password)
      end

      user
    end
  end
end
