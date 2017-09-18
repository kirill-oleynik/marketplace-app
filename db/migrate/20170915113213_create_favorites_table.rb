class CreateFavoritesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.references :user, null: false,
                          foreign_key: { on_delete: :cascade }
      t.references :application, null: false,
                                 foreign_key: { on_delete: :cascade }
      t.timestamps
    end

    add_index :favorites, [:user_id, :application_id], unique: true
  end
end
