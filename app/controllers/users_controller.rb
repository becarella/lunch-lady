class UsersController < ApplicationController

  before_filter :authenticate!
  respond_to :json

  def show
    render json: current_user, serializer: UserSerializer
  end

end
