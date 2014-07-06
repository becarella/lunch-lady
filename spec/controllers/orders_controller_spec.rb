
require "rails_helper"

describe OrdersController do

  describe 'new_email' do
    before do
      post :new_email, {from: 'becarella@gmail.com', to: 'test@example.com', subject: 'cheers!', body: 'making your way in the world today sure does take a lot'}
    end

    specify { expect(response).to be_ok }
  end

end
