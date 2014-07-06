
require "rails_helper"

describe OrdersController do

  describe 'new_email' do
    before do
      @user = VenmoUser.create(email: 'becarella@gmail.com')

      post :new_email, {
        envelope: {
          from: 'becarella@gmail.com', 
          to: 'test@example.com'
        }, 
        headers: {
          subject: 'cheers!'
        }, 
        html: File.read("#{Rails.root}/spec/files/seamless_order_494593308.html")
      }
    end

    specify { 
      expect(response).to be_ok 
      expect(@user.orders.count).to eq(1)
    }
  end

end
