class CreateGalleries < ActiveRecord::Migration[5.1]
  def change
    create_table :galleries do |t|
      t.references :application, null: false,
                                 index: { unique: true },
                                 foreign_key: { on_delete: :cascade }
      t.timestamps
    end
  end
end
