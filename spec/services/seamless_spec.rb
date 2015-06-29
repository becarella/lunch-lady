
require "rails_helper"

describe Order do

  def expect_line_items_to_add_up
    expect(@order.line_items.sum(:subtotal)).to be_within(0.02).of(@order.subtotal)
    expect(@order.line_items.sum(:tax)).to be_within(0.02).of(@order.tax)
    expect(@order.line_items.sum(:delivery)).to be_within(0.02).of(@order.delivery)
    expect(@order.line_items.sum(:discount)).to be_within(0.02).of(@order.discount)
    expect(@order.line_items.sum(:total)).to be_within(0.02).of(@order.total)
  end

  context 'no tip, discount, or delivery' do 
    before do
      user = User.create(email: 'test@example.com')
      html = File.read("#{Rails.root}/spec/files/seamless_order_423043088.html")
      @order = Seamless.new(html, user).parse
    end

    specify do
      expect(@order).to_not be_nil
      expect(@order.restaurant).to eq("Baz Bagel and Restaurant")
      expect(@order.subtotal).to eq(8.0)
      expect(@order.tax).to eq(0.71)
      expect(@order.tip).to eq(0.0)
      expect(@order.discount).to eq(0.0)
      expect(@order.delivery).to eq(0.0)
      expect(@order.total).to eq(8.71)
      expect(@order.line_items.count).to eq(2)
      expect_line_items_to_add_up
    end
  end


  context 'tip' do 
    before do
      user = User.create(email: 'test@example.com')
      html = File.read("#{Rails.root}/spec/files/seamless_order_411296010.html")
      @order = Seamless.new(html, user).parse
    end

    specify do
      expect(@order).to_not be_nil
      expect(@order.restaurant).to eq("The Great Burrito")
      expect(@order.subtotal).to eq(23.75)
      expect(@order.tax).to eq(2.11)
      expect(@order.delivery).to eq(0.0)
      expect(@order.tip).to eq(3.88)
      expect(@order.discount).to eq(0.0)
      expect(@order.total).to eq(29.74)
      expect(@order.line_items.count).to eq(3)
      expect_line_items_to_add_up
    end
  end

  context 'duplicate order' do
    before do
      user = User.create(email: 'test@example.com')
      html = File.read("#{Rails.root}/spec/files/seamless_order_411296010.html")
      Seamless.new(html, user).parse
      Seamless.new(html, user).parse
    end

    specify { expect(Order.count).to eq(1) }
  end
end
