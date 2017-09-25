class CreateApplicationCandidates < ActiveRecord::Migration[5.1]
  def change
    create_table :application_candidates do |t|
      t.string :url, null: false
      t.string :description, null: false
      t.string :user_first_name, null: false
      t.string :user_last_name, null: false
      t.string :user_email, null: false
      t.references :user, foreign_key: { on_delete: :nullify }, allow_nil: true

      t.timestamps
    end
  end
end
