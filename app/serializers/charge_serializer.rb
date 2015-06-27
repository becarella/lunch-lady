class ChargeSerializer < ActiveModel::Serializer
  attributes :user_id, :order_id, :subtotal, :tax, :tip, :discount, :delivery,
             :memo, :charged_to_venmo_id, :charged_by_venmo_id, 
             :payment_source, :payment_id, :created_at, :updated_at

end
