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

class VenmoUser < ActiveRecord::Base

  def get_venmo_friends
    next_url = "https://api.venmo.com/v1/users/795632440705024409/friends?limit=20"
    while !next_url.nil?
      puts next_url
      response = JSON.parse(token.get(next_url).body)
      puts response
      Contact.from_venmo self, response['data']
      next_url = response['pagination']['next']

    end

  end

  def self.accessible_attributes
    VenmoUser.column_names
  end

  def self.from_venmo_authorization json
    json.stringify_keys!
    user = VenmoUser.find_or_create_by(venmo_user_id: json['user']['id'])
    user_data = json.delete('user')
    json.merge!(user_data)
    json['access_token_expires_at'] = Time.at(json['expires_at'])
    json['venmo_user_id'] = json.delete('id')
    json.reject! { |k,v| !VenmoUser.column_names.include?(k.to_s) }
    user.update_attributes(json)
    user
  end

  def token
    @access_token ||= OAuth2::AccessToken.new(VenmoUser.client, self.access_token)
  end

  private

    def self.client 
      @venmo_client ||= OAuth2::Client.new(
        ENV['VENMO_CLIENT_ID'], 
        ENV['VENMO_CLIENT_SECRET'], 
        authorize_url: 'https://api.venmo.com/v1/oauth/authorize',
        token_url: 'https://api.venmo.com/v1/oauth/access_token')
    end

end
