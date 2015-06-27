class AddDeliveryToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :delivery, :float
    add_column :orders, :subtotal, :float
  end
end
