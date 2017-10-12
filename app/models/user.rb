class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :reviews, dependent: :nullify
  has_many :application_candidates, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :favorite_applications, through: :favorites

  delegate :phone, :job_title, :organization, to: :profile, allow_nil: true

  def self.find_by_email(email)
    find_by(email: email)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def favorite_owner?(favorite)
    id == favorite.user_id
  end

  def review_owner?(review)
    id == review.user_id
  end
end
