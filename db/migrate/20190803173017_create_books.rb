class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.date :published_date
      t.text :description
      t.string :genre
      t.string :front_cover
      t.string :back_cover
      t.string :features
      t.boolean :renting
      t.integer :owner_id

      t.timestamps
    end
  end
end
