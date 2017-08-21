class User < ApplicationRecord
  def full_name
    "#{first_name} #{last_name}"
  end

  def find_by_email(value)
    find_by(email: value)
  end
end
