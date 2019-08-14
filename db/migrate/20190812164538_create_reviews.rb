class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.integer :reviewing_id
      t.integer :reviewer_id
      t.text :comment
      t.integer :rating

      t.timestamps
    end
  end
end
