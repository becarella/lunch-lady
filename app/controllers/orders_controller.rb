class OrdersController < ApplicationController
  def index
    render json: current_user.orders.order("created_at desc"), each_serializer: OrderSerializer
  end

  def show
    render json: current_user.orders.find(params[:id]), serializer: OrderSerializer
  end
end
