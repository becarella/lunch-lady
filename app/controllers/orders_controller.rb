class OrdersController < ApplicationController

  def new_email
    Rails.logger.error "NEW EMAIL: #{params.inspect}"
    render json: params
  end

end
