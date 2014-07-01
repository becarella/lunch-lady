class VenmoController < ApplicationController

  def authorize
    redirect_to VenmoUser.client.auth_code.authorize_url(
      redirect_uri: venmo_callback_url, 
      scope: 'make_payments,access_friends,access_email')
  end


  def callback
    response = VenmoUser.client.auth_code.get_token(params[:code], :redirect_uri => venmo_callback_url)
    user = VenmoUser.from_venmo_authorization response.to_hash
    render json: user
  end

end
