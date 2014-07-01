class AddVenmoPaymentIdToCharges < ActiveRecord::Migration
  def change
    add_column :charges, :venmo_payment_id, :string
  end
end
