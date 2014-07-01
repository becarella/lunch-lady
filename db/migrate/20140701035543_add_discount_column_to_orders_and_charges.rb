class AddDiscountColumnToOrdersAndCharges < ActiveRecord::Migration
  def change
    add_column :orders, :discount, :float, default: 0.0
    add_column :charges, :discount, :float, default: 0.0
  end
end
