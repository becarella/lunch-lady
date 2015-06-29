class OrdersController < ApplicationController
  skip_before_filter :verify_authenticity_token, except: [:create]

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

  def create
    Rails.logger.info "#{params.inspect}"
    Seamless.new(params[:html], User.find_by_email(params[:envelope][:from])).parse
    render :text => 'success', :status => 200 # a status of 404 would reject the mail
  end
end
