class MoveToUsers < ActiveRecord::Migration
  def change
    rename_table :venmo_users, :users
    rename_column :contacts, :contact_venmo_user_id, :venmo_id
    rename_column :users, :venmo_user_id, :venmo_id
    remove_column :contacts, :venmo_user_id
  end
end
