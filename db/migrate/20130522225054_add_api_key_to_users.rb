class AddAPIKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :api_key, :string
    add_column :users, :sec_key, :string
  end
end
