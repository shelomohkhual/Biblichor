class CreateRents < ActiveRecord::Migration[6.0]
  def change
    create_table :rents do |t|
      t.integer :book_id
      t.integer :renter_id
      t.integer :owner_id
      t.boolean :renting, default: false

      t.timestamps
    end
  end
end
