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
#  discount      :float            default(0.0)
#



class Seamless

  attr_accessor :html, :user

  def initialize html, user
    @html = html
    @user = user
  end

  def create_order
    json = parse_text
    order = nil
    Order.transaction do
      order_json = json.dup.reject { |k,v| !Order.column_names.include?(k.to_s) }
      order_json[:original_text] = html
      order_json[:user_id] = user.id
      order = Order.find_or_create_by(order_json)
      json[:items].each do |item_json|
        item_json = json.dup.reject { |k,v| !Item.column_names.include?(k.to_s) }
        item_json[:order_id] = order.id
        order.items << Item.find_or_create_by(item_json)
      end
    end
    order
  end

  def parse_text
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
        charge_to_nickname: node.content.strip.match(/\b[A-Z]+\b/)[0],
        description: order.css('td')[2].content.strip,
        subtotal: order.css('td')[6].content.strip.gsub('$', '').to_f
      }
      items.push(current_item)
    end
    
    data[:items] = items
    data
  end
end
