class OrdersController < ApplicationController

  def new_email
    user = User.find_by_email(params[:envelope][:from])
    Order.from_seamless!(user, params[:html])
    render json: params
  end

  def index
    render json: current_user.orders.order("created_at desc")
  end

end
