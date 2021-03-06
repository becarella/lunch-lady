
require "rails_helper"

describe OrdersController do

  describe 'new_email' do
    before do
      @user = User.create(email: 'becarella@gmail.com')

      post :create, {
        envelope: {
          from: 'becarella@gmail.com', 
          to: 'test@example.com'
        }, 
        headers: {
          subject: 'cheers!'
        }, 
        html: File.read("#{Rails.root}/spec/files/seamless_order_411296010.html")
      }
    end

    specify { 
      expect(response).to be_ok 
      expect(@user.orders.count).to eq(1)
    }
  end

end
