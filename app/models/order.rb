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
    end
  end

  def self.parse_seamless html
    doc = Nokogiri::HTML(html)
    
    data = {site: 'Seamless'}
    data[:order_number] = doc.css('h2 span').first.content.gsub('#', '').strip
    data[:restaurant] = doc.css('h2:nth-child(1)').first.content.strip
    data[:subtotal] = doc.css('#ProductTotal').first.content.gsub('$', '').strip.to_f
    doc.css('#ProductTotal').first.parent.parent.remove
    if doc.css('#TipAmount').length > 0
      data[:tip] = doc.css('#TipAmount').first.content.gsub('$', '').strip.to_f 
      doc.css('#TipAmount').first.parent.parent.remove
    else
      data[:tip] = 0.0
    end
    if doc.css('#P3').length > 0
      data[:discount] = doc.css('#P3').first.content.gsub(/[$\(\)]/, '').strip.to_f.abs * -1
      doc.css('#P3').first.parent.parent.remove
    else
      data[:discount] = 0.0
    end
    data[:tax] = doc.css('#SalesTax').first.content.gsub('$', '').strip.to_f
    doc.css('#SalesTax').first.parent.parent.remove
    data[:total] = doc.css('#GrandTotal strong').first.content.gsub('$', '').strip.to_f
    doc.css('#GrandTotal').first.parent.parent.remove

    items = [];
    current_item = {};
    count = 0;
    doc.css('table:nth-child(3) tr').each do |node|
      begin
        if count % 2 == 0  # order summary
          current_item[:memo] = node.css('td:nth-child(2) p strong').first.content.strip
          current_item[:subtotal] = node.css('td:nth-child(6) p').first.content.strip.gsub('$', '').to_f
          current_item[:tax] = (current_item[:subtotal] / data[:subtotal] * data[:tax]).round(2)
          current_item[:tip] = (current_item[:subtotal] / data[:subtotal] * data[:tip]).round(2)
          current_item[:discount] = (current_item[:subtotal] / data[:subtotal] * data[:discount]).round(2)
        else               # order special instructions
          current_item[:nickname] = node.css('td:nth-child(2) ul li strong').first.content.strip.match(/\b[A-Z]+\b/)[0]
          items.push(current_item)
          current_item = {}
        end
      rescue => e
        Rails.logger.error e.message
        Rails.logger.error node.content
      end
      count += 1
    end
    
    data[:items] = items
    data
  end

end
