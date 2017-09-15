class Application < ApplicationRecord
  SLUG_REGEXP = /^[a-z0-9-]+$/

  has_many :application_categories, dependent: :destroy
  has_many :categories, through: :application_categories

  has_one :application_attachment, dependent: :destroy
  has_one :attachment, through: :application_attachment

  def self.find_by_slug!(slug)
    find_by!(slug: slug)
  end

  def logo
    attachment.try(:url)
  end
end