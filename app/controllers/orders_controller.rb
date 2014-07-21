class OrdersController < ApplicationController

  def new_email
    user = VenmoUser.find_by_email(params[:envelope][:from])
    order = Order.from_seamless!(user, params[:html])
    order.charge_new
    render json: {}
  end

end
