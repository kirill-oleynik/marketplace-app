class GalleryAttachment < ApplicationRecord
  belongs_to :gallery
  belongs_to :attachment

  delegate :url, to: :attachment
end
