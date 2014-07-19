class OrdersController < ApplicationController

  def new_email
    user = VenmoUser.find_by_email(params[:envelope][:from])
    Rails.logger.info "USER: #{user.inspect}"
    Rails.logger.info "HTML:"
    Rails.logger.info params[:html]
    
    Order.from_seamless!(user, params[:html])
    Rails.logger.info "ORDER: #{order.inspect}"
    render json: params
  end

end
