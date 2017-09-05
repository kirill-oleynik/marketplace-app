class ChangeProfileColumnsNullable < ActiveRecord::Migration[5.1]
  def up
    change_column_null :profiles, :phone, true
    change_column_null :profiles, :job_title, true
    change_column_null :profiles, :organization, true
  end

  def down
    change_column_null :profiles, :phone, false, default: ''
    change_column_null :profiles, :job_title, false, default: ''
    change_column_null :profiles, :organization, false, default: ''
  end
end
