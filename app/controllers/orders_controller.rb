class OrdersController < ApplicationController

  def new_email
    render json: params
  end


end
