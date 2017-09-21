class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :application

  def self.find_by_user_and_application(user:, application:)
    find_by(user_id: user.id, application_id: application.id)
  end

  def self.all_for_user(user)
    where(user_id: user.id).order(created_at: :desc)
  end
end
