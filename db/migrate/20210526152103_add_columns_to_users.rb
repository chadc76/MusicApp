class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activation_token, :string, null: false
    add_index :users, :activation_token, unique: true
  end
end
