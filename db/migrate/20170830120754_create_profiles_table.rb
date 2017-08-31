class CreateProfilesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :profiles do |t|
      t.bigint :user_id, null: false
      t.string :phone, null: false
      t.string :job_title, null: false
      t.string :organization, null: false
    end

    add_index :profiles, :user_id, unique: true
    add_foreign_key :profiles, :users, on_delete: :cascade
  end
end
