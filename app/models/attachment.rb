class Attachment < ApplicationRecord
  mount_uploader :filename, AttachmentUploader

  def url
    filename.url
  end
end
