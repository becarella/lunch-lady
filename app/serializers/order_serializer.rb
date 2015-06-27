class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :site, :original_text, :restaurant, :order_number, 
             :total, :tip, :discount, :delivery, :tax, :created_at, :updated_at
  
  has_many :line_items
  has_one :user
end
