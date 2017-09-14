class Category < ApplicationRecord
  has_many :application_categories
  has_many :applications, through: :application_categories

  def self.all_with_applications
    all.includes(:applications)
  end
end
