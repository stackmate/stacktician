class AddApikeysToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cs_api_key, :string
    add_column :users, :cs_sec_key, :string
    User.reset_column_information
    User.skip_callback(:save, :before, :perhaps_get_keys)
    User.find_each do |u|
      if !u.api_key.nil?
        u.update_attribute(:cs_api_key,u.api_key)
        u.update_attribute(:api_key,nil)
      end
      if !u.sec_key.nil?
        u.update_attribute(:cs_sec_key,u.sec_key)
        u.update_attribute(:sec_key,nil)
      end
    end
  end
end