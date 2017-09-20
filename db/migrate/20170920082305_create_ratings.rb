class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.integer :one_points_votes, null: false, default: 0
      t.integer :two_points_votes, null: false, default: 0
      t.integer :three_points_votes, null: false, default: 0
      t.integer :four_points_votes, null: false, default: 0
      t.integer :five_points_votes, null: false, default: 0

      t.references :application,
                   null: false,
                   foreign_key: { on_delete: :cascade },
                   index: { unique: true }

      t.timestamps
    end
  end
end
