class CreateGalleryAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :gallery_attachments do |t|
      t.references :gallery, null: false,
                             index: false,
                             foreign_key: { on_delete: :cascade }

      t.references :attachment, null: false,
                                index: false,
                                foreign_key: { on_delete: :cascade }

      t.string :title
      t.string :description

      t.timestamps
    end

    add_index :gallery_attachments, [:gallery_id, :attachment_id], unique: true
  end
end
