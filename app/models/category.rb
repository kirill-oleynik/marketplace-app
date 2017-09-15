class Category < ApplicationRecord
  has_many :application_categories
  has_many :applications, through: :application_categories

  default_scope do
    includes(applications: [:application_attachment, :attachment])
  end

  def applications_count
    applications.size
  end
end
