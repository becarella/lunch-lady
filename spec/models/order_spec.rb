# == Schema Information
#
# Table name: venmo_users
#
#  id                      :integer          not null, primary key
#  venmo_user_id           :string(255)
#  username                :string(255)
#  first_name              :string(255)
#  last_name               :string(255)
#  email                   :string(255)
#  phone                   :string(255)
#  access_token            :string(255)
#  access_token_expires_at :datetime
#  refresh_token           :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

require "rails_helper"

describe Order do

  context 'no tip' do 
    before do
      @user = VenmoUser.create(email: 'becarella@gmail.com')
      html = File.read("#{Rails.root}/spec/files/seamless_order_494593308.html")
      @order = Order.from_seamless!(@user, html)
    end

    specify do
      expect(@order).to_not be_nil
      expect(@order.restaurant).to eq("An Choi")
    end



  end

  before do
    Order.stub(:charge_contact_on_venmo).and_return(1234)
  end



end
