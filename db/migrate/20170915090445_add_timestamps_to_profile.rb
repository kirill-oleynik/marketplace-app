class AddTimestampsToProfile < ActiveRecord::Migration[5.1]
  def up
    add_column :profiles, :created_at, :datetime
    add_column :profiles, :updated_at, :datetime

    Profile.find_each do |profile|
      profile.update!(
        created_at: profile.user.created_at,
        updated_at: profile.user.updated_at
      )
    end

    change_column :profiles, :created_at, :datetime, null: false
    change_column :profiles, :updated_at, :datetime, null: false
  end

  def down
    remove_column :profiles, :created_at
    remove_column :profiles, :updated_at
  end
end
