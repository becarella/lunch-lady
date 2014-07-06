class OrdersController < ApplicationController

  def new_email
    Rails.logger.debug params.inspect
    render json: params
  end


end
