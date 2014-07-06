class OrdersController < ApplicationController

  def new_email
    Rails.logger.info "NEW EMAIL: #{params.inspect}"
    render json: params
  end

end
