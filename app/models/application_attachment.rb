class ApplicationAttachment < ApplicationRecord
  belongs_to :application
  belongs_to :attachment
end
