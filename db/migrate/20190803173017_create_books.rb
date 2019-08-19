class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.date :published_date
      t.text :description
      t.string :genre
      t.string :cover
      t.string :features
      t.boolean :renting
      t.integer :user_id
      t.decimal :price, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
