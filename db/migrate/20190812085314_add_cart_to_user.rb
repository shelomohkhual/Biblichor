class AddCartToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :cart, :text
  end
end
