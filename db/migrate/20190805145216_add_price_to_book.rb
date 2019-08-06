class AddPriceToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :price, :float
  end
end
