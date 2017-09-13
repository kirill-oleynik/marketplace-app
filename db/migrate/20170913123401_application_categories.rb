class ApplicationCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :application_categories do |t|
      t.belongs_to :application
      t.belongs_to :category

      t.timestamps
    end

    add_index :application_categories,
              [:application_id, :category_id],
              unique: true
  end
end
