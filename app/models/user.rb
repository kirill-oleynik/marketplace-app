class User < ApplicationRecord
  has_one :profile, dependent: :destroy

  delegate :phone, :job_title, :organization, to: :profile, allow_nil: true

  def self.find_by_email(value)
    find_by(email: value)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
