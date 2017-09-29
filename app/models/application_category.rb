class ApplicationCategory < ApplicationRecord
  belongs_to :application
  belongs_to :category, counter_cache: true
end
