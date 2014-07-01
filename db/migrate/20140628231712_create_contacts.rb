class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer       :user_id
      t.string        :venmo_user_id
      t.string        :contact_venmo_user_id
      t.string        :username
      t.string        :nickname
      t.timestamps
    end
  end
end
