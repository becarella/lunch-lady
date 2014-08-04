class VenmoController < ApplicationController

  def authorize
    Rails.logger.debug "SESSION: #{session[:user_id].inspect}"
    # if session[:user_id]
    #   redirect_to params['redirect_url'] and return
    # end
    session[:redirect_on_venmo_callback] = params['redirect_url']
    redirect_to User.client.auth_code.authorize_url(
      redirect_uri: venmo_callback_url, 
      scope: 'make_payments,access_friends,access_email')
  end


  def callback
    redirect_url = session[:redirect_on_venmo_callback]
    response = User.client.auth_code.get_token(params[:code], :redirect_uri => venmo_callback_url)
    user = User.from_venmo_authorization response.to_hash
    # reset_session
    session[:user_id] = user.id
    puts "CALLBACK SESSION USER: #{session[:user_id]}"
    redirect_to redirect_url
  end

  def logout
    reset_session
    render json: {}
  end

end
