class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer       :user_id
      t.string        :site
      t.text          :original_text
      t.string        :site
      t.string        :restaurant
      t.string        :order_number
      t.float         :total
      t.float         :tip
      t.float         :tax
      t.timestamps
    end
  end
end
