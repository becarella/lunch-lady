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

  before do
    Order.stub(:charge_contact_on_venmo).and_return(1234)
  end

end
