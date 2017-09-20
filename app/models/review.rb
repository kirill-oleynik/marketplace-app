class Review < ApplicationRecord
  belongs_to :user
  belongs_to :application

  def self.find_value_by_user_and_application(application:, user:)
    find_by(application: application, user: user).try(:value)
  end
end
