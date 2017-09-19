class AddSummaryToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :summary, :string, null: false, default: ''
  end
end
