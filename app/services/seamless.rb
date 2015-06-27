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

  def parse
    json = parse_text
    order = nil
    Order.transaction do
      order_json = json.dup.reject { |k,v| !Order.column_names.include?(k.to_s) }
      order_json[:original_text] = html
      order_json[:user_id] = user.id
      order = Order.find_or_create_by(order_json)
      json[:items].each do |item_json|
        item_json = json.dup.reject { |k,v| !LineItem.column_names.include?(k.to_s) }
        item_json[:order_id] = order.id
        puts "ITEM JSON: #{item_json.inspect}"
        order.line_items << LineItem.find_or_create_by(item_json)
      end
    end
    order.reload
  end

  def parse_text
    doc = Nokogiri::HTML(html)
    data = {site: 'Seamless'}
    data[:order_number] = doc.search("[text()*='Order #']").first.content.match(/\d+/)[0]
    data[:restaurant] = doc.search('h4').first.content
    data[:subtotal] = doc.search("[text()*='Subtotal']").first.ancestors('tr').search("[text()*='$']").first.content.gsub('$', '').strip.to_f
    data[:tax] = doc.search("[text()*='Sales Tax']").first.ancestors('tr').search("[text()*='$']").first.content.gsub('$', '').strip.to_f
    begin
      data[:tip] = doc.search("[text()*='Tip Amount']").first.ancestors('tr').search("[text()*='$']").first.content.gsub('$', '').strip.to_f
    rescue
      data[:tip] = 0.0
    end
    begin
      data[:discount] = doc.search("[text()*='Restaurant Deal']").first.ancestors('tr').search("[text()*='$']").first.content.gsub(/[$\(\)]/, '').strip.to_f.abs * -1
    rescue
      data[:discount] = 0.0
    end
    data[:total] = doc.search("[text()*='Total']").first.ancestors('tr').search("[text()*='$']").first.content.gsub('$', '').strip.to_f

    items = [];
    count = 0;
    doc.search("[text()*='$']").first.ancestors('table').first.ancestors('tbody').first.search('> tr').each do |node|
      items.push({
        charge_to_nickname: node.search("[text()*='Special Instructions']").first.content.strip.match(/\b[A-Z]+\b/)[0],
        description: node.search('td')[1].content.strip,
        subtotal: node.search('td')[2].content.strip.gsub('$', '').to_f
      })
    end
    puts "ITEMS: #{items.inspect}"
    data[:items] = items
    data
  end
end
