class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.integer :value, null: false
      t.references :user,
                   null: false,
                   foreign_key: { on_delete: :nullify }
      t.references :application,
                   null: false,
                   foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_index :reviews, [:user_id, :application_id], unique: true
  end
end
