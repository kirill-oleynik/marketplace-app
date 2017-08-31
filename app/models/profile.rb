class Profile < ApplicationRecord
  belongs_to :user

  def self.find_by_user_id(user_id)
    find_by(user_id: user_id)
  end
end
