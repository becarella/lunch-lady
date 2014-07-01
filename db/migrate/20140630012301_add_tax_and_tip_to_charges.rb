class AddTaxAndTipToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :tax, :float, default: 0
    add_column :charges, :tip, :float, default: 0
  end
end
