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
#  total         :float
#  tip           :float
#  tax           :float
#  created_at    :datetime
#  updated_at    :datetime
#

class Order < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  has_many :charges
  belongs_to :venmo_user, foreign_key: :user_id


  def charge_new
    new_charges_by_contact.each do |charge|
      charge_contact(charge)
    end
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
      user_id: charge.contact_venmo_user_id,
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
      group('charges.order_id, contacts.contact_venmo_user_id, charges.contact_id').
      all
  end

  def self.from_seamless! venmo_user, html
    json = Order.parse_seamless(html)
    Order.transaction do
      order_json = json.dup.reject { |k,v| !Order.column_names.include?(k.to_s) }
      order_json[:original_text] = html
      order_json[:user_id] = venmo_user.id
      order = Order.find_or_create_by(order_json)
      json[:items].each do |item_json|
        Charge.from_seamless_json(order, item_json)
      end
      order
    end
  end

  def self.parse_seamless html
    doc = Nokogiri::HTML(html)
    data = {site: 'Seamless'}
    data[:order_number] = doc.search("[text()*='Order']").first.content.match(/\d+/)[0]
    data[:restaurant] = doc.search("[text()*='Order']").first.ancestors('tr').first.css('td').first.content.strip.split(/\n/).first.strip
    data[:subtotal] = doc.search("[text()*='Product Total']").first.ancestors('tr').search("[text()*='$']").first.content.gsub('$', '').strip.to_f
    data[:tax] = doc.search("[text()*='Sales Tax']").first.ancestors('tr').search("[text()*='$']").first.content.gsub('$', '').strip.to_f
    begin
      data[:tip] = doc.search("[text()*='Tip']").first.ancestors('tr').search("[text()*='$']").first.content.gsub('$', '').strip.to_f
    rescue
      data[:tip] = 0.0
    end
    begin
      data[:discount] = doc.search("[text()*='Restaurant Deal']").first.ancestors('tr').search("[text()*='$']").first.content.gsub(/[$\(\)]/, '').strip.to_f.abs * -1
    rescue
      data[:discount] = 0.0
    end
    data[:total] = doc.search("[text()*='Grand Total']").first.ancestors('tr').search("[text()*='$']").first.content.gsub('$', '').strip.to_f

    items = [];
    count = 0;
    doc.search("[text()*='Special Instructions']").each do |node|
      order = node.ancestors('tr').first.parent.css('tr')
      current_item = {
        nickname: node.content.strip.match(/\b[A-Z]+\b/)[0],
        memo: order.css('td')[2].content.strip,
        subtotal: order.css('td')[6].content.strip.gsub('$', '').to_f
      }
      current_item.merge!({
        tax: (current_item[:subtotal] / data[:subtotal] * data[:tax]).round(2),
        tip: (current_item[:subtotal] / data[:subtotal] * data[:tip]).round(2),
        discount: (current_item[:subtotal] / data[:subtotal] * data[:discount]).round(2)
      })
      items.push(current_item)
    end
    
    data[:items] = items
    data
  end

end
