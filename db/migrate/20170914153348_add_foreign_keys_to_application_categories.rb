class AddForeignKeysToApplicationCategories < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :application_categories, :categories, on_delete: :cascade
    add_foreign_key :application_categories, :applications, on_delete: :cascade
  end
end
