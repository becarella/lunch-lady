class OrdersController < ApplicationController

  def new_email
    # user = VenmoUser.find_by_email(params[:envelope][:from])
    logger.info "NEW_EMAIL WRITING TO FILE #{params[:html].encoding}"
    File.open('/tmp/seamless_order.html', 'wb') do |file|
      file << params[:html]
    end
    logger.warn "NEW_EMAIL WROTE TO FILE"
    File.new('/tmp/seamless_order.html').save_to_s3('lunch_lady', 'orders', 'seamless_order.html')
    logger.warn "NEW_EMAIL SAVED TO S3"

    logger.warn "FILE CONTENTS:"
    logger.warn File.read('/tmp/seamless_order.html')
    # Order.from_seamless!(user, params[:html])
    # Rails.logger.info "ORDER: #{order.inspect}"
    # render json: params
    render json: {}
  end

end
