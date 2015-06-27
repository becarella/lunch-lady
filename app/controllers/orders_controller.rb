class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.order("created_at desc")
    respond_to do |format|
      format.html
      format.json { render json: @orders, each_serializer: OrderSerializer }
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @order, serializer: OrderSerializer }
    end
  end

  def charge
    @order = current_user.orders.find(params[:id])
    @order.charge!
    respond_to do |format|
      format.html
      format.json { render json: @order, serializer: OrderSerializer }
    end
  end
end
