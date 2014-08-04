# == Schema Information
#
# Table name: charges
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  contact_id       :integer
#  order_id         :integer
#  subtotal         :float
#  memo             :text
#  created_at       :datetime
#  updated_at       :datetime
#  venmo_payment_id :string(255)
#  tax              :float            default(0.0)
#  tip              :float            default(0.0)
#  discount         :float            default(0.0)
#

class Charge < ActiveRecord::Base

  def self.from_seamless_json order, charge_json
    charge_json.symbolize_keys!
    charge_json[:user_id] = order.user_id
    charge_json[:order_id] = order.id
    charge_json[:contact_id] = Contact.find_by(user_id: order.user_id, nickname: charge_json.delete(:nickname)).try(:id)
    Charge.create(charge_json)
  end

end
