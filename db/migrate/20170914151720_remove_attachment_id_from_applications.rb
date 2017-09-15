class RemoveAttachmentIdFromApplications < ActiveRecord::Migration[5.1]
  def up
    remove_column :applications, :attachment_id
  end

  def down
    add_column :applications, :attachment_id, index: { unique: true }
    add_foreign_key :applications, :attachments, on_delete: :cascade
  end
end
