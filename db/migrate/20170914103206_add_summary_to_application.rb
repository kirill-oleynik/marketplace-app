class AddSummaryToApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :applications, :summary, :string, null: false, default: ''
  end
end
