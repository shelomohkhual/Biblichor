class AddNameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :username, :string, unique: true
    add_column :users, :image, :string
  end
end
