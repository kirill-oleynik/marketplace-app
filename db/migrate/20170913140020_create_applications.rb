class CreateApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :applications do |t|
      t.string :slug, null: false, index: { unique: true }
      t.string :title, null: false
      t.string :description, null: false
      t.string :website, null: false
      t.string :email, null: false
      t.string :address
      t.string :phone
      t.date :founded
      t.bigint :attachment_id, null: false, index: { unique: true }

      t.timestamps
    end

    add_foreign_key :applications, :attachments, on_delete: :cascade
  end
end
