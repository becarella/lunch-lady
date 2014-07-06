class OrdersController < ApplicationController

  def new_email
    Rails.logger.info params.inspect
    render json: params
  end

end
