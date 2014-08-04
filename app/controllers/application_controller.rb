class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  include SessionHelper

  before_filter :cors_set_access_control_headers

  # For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
    cors_headers
  end

  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain.
  def cors_preflight_check
    cors_headers
    render :text => '', :content_type => 'text/plain'
  end

  # Set of headers to return for CORS checks
  def cors_headers
  
    return if request.referrer.blank?

    referrer = nil
    begin
      referrer = URI.parse(request.referrer)
    rescue URI::InvalidURIError
      begin
        referrer = URI.parse(URI.encode(request.referrer))
      rescue
        referrer = nil
      end
    end

    return if referrer.blank?

    headers['Access-Control-Allow-Origin'] = "#{referrer.scheme}://#{referrer.host}:#{referrer.port}"
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Content-Type, X-Requested-With, X-Prototype-Version, X-CSRF-Token'
    headers['Access-Control-Allow-Credentials'] = 'true'
    headers['Access-Control-Max-Age'] = '1728000'
  end

end
