class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.integer :rating_stars , default: 1
      t.text :comments
      t.integer :rater_id
      t.integer :book_id
      t.integer :user_id

      t.timestamps
    end
  end
end
