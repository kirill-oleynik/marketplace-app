class Category < ApplicationRecord
  has_many :application_categories
  has_many :applications, through: :application_categories

  default_scope do
    includes(applications: [:application_attachment, :attachment])
  end

  def self.search(query:)
    like_query = "%#{query}%"

    where('title ilike ? or summary ilike ?', like_query, like_query)
  end

  def applications_count
    applications.size
  end
end
