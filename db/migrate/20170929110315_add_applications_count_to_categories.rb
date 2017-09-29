class AddApplicationsCountToCategories < ActiveRecord::Migration[5.1]
  def self.up
    add_column :categories, :application_categories_count, :integer, default: 0

    Category.reset_column_information

    Category.find_each do |category|
      Category.update_counters(
        category.id,
        application_categories_count: category.application_categories.length
      )
    end
  end

  def self.down
    remove_column :categories, :application_categories_count
  end
end
