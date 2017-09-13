class CreateAttachmentsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string :filename, null: false
      t.string :original_filename, null: false
      t.string :size, null: false
      t.string :content_type, null: false

      t.timestamps
    end
  end
end
