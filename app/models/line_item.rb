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

class LineItem < ActiveRecord::Base

  belongs_to :order
  belongs_to :charge

  scope :uncharged, where('charge_id is null')
  scope :charged, where('charge_id is not null')

  before_create :update_amounts

  def update_amounts
    puts "UPDATE AMOUNTS #{order.inspect}"
    percentage = subtotal / order.subtotal
    puts "PERCENTAGE: #{percentage}"
    self.tip = (order.tip * percentage).round(2)
    self.tax = (order.tax * percentage).round(2)
    self.delivery = (order.delivery * percentage).round(2)
    self.discount = (order.discount * percentage).round(2)
    self.total = (self.subtotal + self.tip + self.tax + self.delivery + self.discount).round(2)
    puts "LINE ITEM: #{inspect}"
  end
end
