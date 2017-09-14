class ApplicationCategory < ApplicationRecord
  belongs_to :application
  belongs_to :category
end
