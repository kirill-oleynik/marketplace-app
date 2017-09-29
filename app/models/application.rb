class Application < ApplicationRecord
  SLUG_REGEXP = /^[a-z0-9-]+$/

  has_many :application_categories, dependent: :destroy
  has_many :categories, through: :application_categories
  has_many :favorites, dependent: :destroy

  has_one :application_attachment, dependent: :destroy
  has_one :attachment, through: :application_attachment
  has_one :rating, dependent: :destroy

  default_scope do
    includes(:application_attachment, :attachment)
  end

  def self.find_by_slug!(slug)
    find_by!(slug: slug)
  end

  def self.search(query:)
    like_query = "%#{query}%"

    where(
      'title ilike ? or summary ilike ? or description ilike ?',
      like_query, like_query, like_query
    )
  end

  def categories_ids
    categories.distinct.ids
  end

  def logo
    attachment.try(:url)
  end
end
