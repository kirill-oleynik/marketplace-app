class Application < ApplicationRecord
  has_many :application_categories
  has_many :categories, through: :application_categories
  belongs_to :attachment
end
