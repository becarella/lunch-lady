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

describe VenmoUser do

  let(:json) { JSON.parse(File.read("#{Rails.root}/spec/files/venmo_auth_token_response.json")) }

  shared_examples_for "a venmo user" do 
    it "should match the venmo json" do
      user = VenmoUser.from_venmo_authorization(json.dup)
      expect(user.venmo_user_id).to eq(json['user']['id'])
      expect(user.username).to eq(json['user']['username'])
      expect(user.first_name).to eq(json['user']['first_name'])
      expect(user.last_name).to eq(json['user']['last_name'])
      expect(user.email).to eq(json['user']['email'])
      expect(user.phone).to eq(json['user']['phone'])
      expect(user.access_token).to eq(json['access_token'])
      expect(user.refresh_token).to eq(json['refresh_token'])
      expect(user.access_token_expires_at.to_i).to eq(json['expires_at'])
    end
  end

  context "a new user" do
    it_should_behave_like "a venmo user"
  end


  context "an existing user" do
    before do
      VenmoUser.create(venmo_user_id:json['user']['id'])
    end

    it_should_behave_like "a venmo user"
  end
end
