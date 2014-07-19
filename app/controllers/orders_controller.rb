class OrdersController < ApplicationController

  def new_email
    user = VenmoUser.find_by_email(params[:envelope][:from])
    Rails.logger.info "USER: #{user.inspect}"
    Rails.logger.info "HTML:"
    Rails.logger.info params[:html]
    File.write('/tmp/seamless_order.html', params[:html])
    f = File.new('/tmp/seamless_order.html')
    f.save_to_s3('lunch_lady', 'orders', 'seamless_order.html')
    Order.from_seamless!(user, params[:html])
    Rails.logger.info "ORDER: #{order.inspect}"
    render json: params
  end

end
