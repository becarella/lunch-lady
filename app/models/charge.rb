# == Schema Information
#
# Table name: charges
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  order_id            :integer
#  subtotal            :float            default(0.0)
#  memo                :text
#  created_at          :datetime
#  updated_at          :datetime
#  tax                 :float            default(0.0)
#  tip                 :float            default(0.0)
#  discount            :float            default(0.0)
#  charged_to_venmo_id :string(255)
#  charged_by_venmo_id :string(255)
#  payment_source      :string(255)
#  payment_id          :string(255)
#  delivery            :float            default(0.0)
#  total               :float            default(0.0)
#

class Charge < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  has_many :line_items
end
