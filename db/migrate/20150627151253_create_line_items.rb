class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer       :order_id
      t.integer       :charge_id
      t.float         :subtotal
      t.float         :tax
      t.float         :tip
      t.float         :delivery
      t.float         :discount
      t.float         :total
      t.string        :charge_to_nickname
      t.string        :charge_to_venmo
      t.text          :description
      t.timestamps
    end
  end
end
