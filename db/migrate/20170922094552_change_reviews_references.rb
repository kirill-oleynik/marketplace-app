class ChangeReviewsReferences < ActiveRecord::Migration[5.1]
  def up
    remove_reference :reviews, :application

    add_reference :reviews, :rating,
                  foreign_key: { on_delete: :cascade },
                  null: false

    add_index :reviews, [:user_id, :rating_id], unique: true
  end

  def down
    remove_reference :reviews, :rating

    add_reference :reviews, :application,
                  foreign_key: { on_delete: :cascade },
                  null: false

    add_index :reviews, [:user_id, :application_id], unique: true
  end
end
