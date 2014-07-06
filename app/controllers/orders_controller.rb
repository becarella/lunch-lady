class OrdersController < ApplicationController

  def new_email
    Rails.logger.error "NEW EMAIL: #{params.inspect}"
    user = VenmoUser.find_by_email(params[:envelope][:from])
    Order.from_seamless!(user, params[:html])
    render json: params
  end

end
