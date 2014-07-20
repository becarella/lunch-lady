class OrdersController < ApplicationController

  def new_email
    user = VenmoUser.find_by_email(params[:envelope][:from])
    Order.from_seamless!(user, params[:html])
    render json: params
  end

end
