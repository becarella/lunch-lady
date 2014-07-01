class CreateVenmoUsers < ActiveRecord::Migration
  def change
    create_table :venmo_users do |t|
      t.string      :venmo_user_id
      t.string      :username
      t.string      :first_name
      t.string      :last_name
      t.string      :email
      t.string      :phone
      t.string      :access_token
      t.timestamp   :access_token_expires_at
      t.string      :refresh_token
      t.timestamps
    end
  end
end
