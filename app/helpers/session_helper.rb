module SessionHelper

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate!
    unless current_user
      render json: {error: 'wtf'}, status: :unauthorized
    end
  end
end
