class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.integer     :user_id
      t.integer     :contact_id
      t.integer     :order_id
      t.float       :subtotal
      t.text        :memo
      t.timestamps
    end
  end
end
