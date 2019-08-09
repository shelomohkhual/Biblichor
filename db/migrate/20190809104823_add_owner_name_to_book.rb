class AddOwnerNameToBook < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :owner_name, :string
  end
end
