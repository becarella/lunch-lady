class AddDefaults < ActiveRecord::Migration
  def change
    change_column :orders, :subtotal, :float, default: 0.0
    change_column :orders, :tip, :float, default: 0.0
    change_column :orders, :tax, :float, default: 0.0
    change_column :orders, :discount, :float, default: 0.0
    change_column :orders, :delivery, :float, default: 0.0
    change_column :orders, :total, :float, default: 0.0

    change_column :line_items, :subtotal, :float, default: 0.0
    change_column :line_items, :tip, :float, default: 0.0
    change_column :line_items, :tax, :float, default: 0.0
    change_column :line_items, :discount, :float, default: 0.0
    change_column :line_items, :delivery, :float, default: 0.0
    change_column :line_items, :total, :float, default: 0.0

    change_column :charges, :subtotal, :float, default: 0.0
    change_column :charges, :tip, :float, default: 0.0
    change_column :charges, :tax, :float, default: 0.0
    change_column :charges, :discount, :float, default: 0.0
    change_column :charges, :delivery, :float, default: 0.0
    add_column :charges, :total, :float, default: 0.0

  end
end
