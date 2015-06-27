class LineItemSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :subtotal, :tax, :tip, :delivery, :discount, :total,
             :charge_to_nickname, :charge_to_venmo, :description, :created_at, :updated_at        

  has_one :charge
end
