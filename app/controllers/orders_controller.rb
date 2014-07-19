class OrdersController < ApplicationController

  def new_email
    user = VenmoUser.find_by_email(params[:envelope][:from])
    File.write('/tmp/seamless_order.html', params[:html])
    Rails.logger.info 'saving file...'
    f = File.new('/tmp/seamless_order.html')
    f.save_to_s3('lunch_lady', 'orders', 'seamless_order.html')
    Rails.logger.info 'saved file...'
    # Order.from_seamless!(user, params[:html])
    # Rails.logger.info "ORDER: #{order.inspect}"
    render json: params
  end

end
