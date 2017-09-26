class ApplicationCandidate < ApplicationRecord
  belongs_to :user, optional: true
end
