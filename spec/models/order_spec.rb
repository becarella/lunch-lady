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

require "rails_helper"

describe Order do

  before do
    Order.stub(:charge_contact_on_venmo).and_return(1234)
  end

  context 'no tip' do 
    before do
      @user = User.create(email: 'becarella@gmail.com')
      html = File.read("#{Rails.root}/spec/files/seamless_order_494593308.html")
      @order = Order.from_seamless!(@user, html)
    end

    specify do
      expect(@order).to_not be_nil
      expect(@order.restaurant).to eq("An Choi")
    end
  end


  context 'forwarded email' do
    before do
      @user = User.create(email: 'becarella@gmail.com')
      html = File.read("#{Rails.root}/spec/files/forwarded_order.html")
      @order = Order.from_seamless!(@user, html)    
    end

    specify do
      expect(@order).to_not be_nil
      expect(@order.restaurant).to eq("Mooncake Foods (Watts St)")
    end
  end

  context 'restaurant deal' do
    before do
      @user = User.create(email: 'becarella@gmail.com')
      html = File.read("#{Rails.root}/spec/files/seamless_order_509624082.html")
      @order = Order.from_seamless!(@user, html)    
    end

    specify do
      expect(@order).to_not be_nil
      expect(@order.discount).to eq(-7.69)
    end
  end
  

end
