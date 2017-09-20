class Gallery < ApplicationRecord
  belongs_to :application

  has_many :gallery_attachments, dependent: :destroy
  has_many :attachments, through: :gallery_attachments

  def self.find_by_application_id!(application_id)
    find_by!(application_id: application_id)
  end

  class Null < self
  end
end
