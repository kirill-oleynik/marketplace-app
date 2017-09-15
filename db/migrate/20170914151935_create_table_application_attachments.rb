class CreateTableApplicationAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :application_attachments, id: false do |t|
      t.primary_key :application_id
      t.references :attachment, null: false,
                                index: { unique: true },
                                foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_foreign_key :application_attachments, :applications, on_delete: :cascade
  end
end
