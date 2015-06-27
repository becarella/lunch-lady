# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  site          :string(255)
#  original_text :text
#  restaurant    :string(255)
#  order_number  :string(255)
#  total         :float            default(0.0)
#  tip           :float            default(0.0)
#  tax           :float            default(0.0)
#  created_at    :datetime
#  updated_at    :datetime
#  discount      :float            default(0.0)
#  delivery      :float            default(0.0)
#  subtotal      :float            default(0.0)
#

class Order < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :user
  has_many :charges
  has_many :line_items


  def charge
    # TODO:
    # Group uncharged line items
    # Create charges for line items
    # Charge on venmo
  end

  def charge_contact charge
    components = {
      subtotal: charge.subtotal,
      tip: charge.tip,
      tax: charge.tax
    }
    components = components.select { |k,v| v != 0 }.map{ |k,v| "#{number_to_currency(v)} #{k}" }.join(' + ')
    components << " - #{number_to_currency(charge.discount.abs)} discount" if charge.discount != 0
    charge_params = {
      user_id: charge.venmo_id,
      note: [self.restaurant, components].join(' | '),
      amount: charge.total.abs * -1
    }
    payment_id = charge_contact_on_venmo(charge_params)
    Charge.where(order_id: self.id, contact_id: charge.contact_id).update_all({venmo_payment_id: payment_id})
  end

  def charge_contact_on_venmo params
    response = venmo_user.token.post('https://api.venmo.com/v1/payments', params: params) # if Rails.env.production?
    data = JSON.parse(response.body)
    data['data']['payment']['id']
  end

  def new_charges_by_contact
    charges.
      joins('left join contacts on contacts.id=charges.contact_id').
      select("string_agg(memo, ', ') as memo, sum(subtotal + tax + tip + discount) as total, sum(subtotal) as subtotal, sum(tax) as tax, sum(tip) as tip, sum(discount) as discount, charges.contact_id, contacts.contact_venmo_user_id").
      where("contacts.contact_venmo_user_id is not null").
      where('charges.venmo_payment_id is null').
      group('charges.order_id, contacts.venmo_id, charges.contact_id').
      all
  end

end
