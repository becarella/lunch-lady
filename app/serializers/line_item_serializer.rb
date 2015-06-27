# == Schema Information
#
# Table name: line_items
#
#  id                 :integer          not null, primary key
#  order_id           :integer
#  charge_id          :integer
#  subtotal           :float            default(0.0)
#  tax                :float            default(0.0)
#  tip                :float            default(0.0)
#  delivery           :float            default(0.0)
#  discount           :float            default(0.0)
#  total              :float            default(0.0)
#  charge_to_nickname :string(255)
#  charge_to_venmo    :string(255)
#  description        :text
#  created_at         :datetime
#  updated_at         :datetime
#

class LineItemSerializer < ActiveModel::Serializer
  attributes :id, :order_id, :subtotal, :tax, :tip, :delivery, :discount, :total,
             :charge_to_nickname, :charge_to_venmo, :description, :created_at, :updated_at        

  has_one :charge
end
