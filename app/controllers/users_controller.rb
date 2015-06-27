class UsersController < ApplicationController

  before_filter :authenticate!
  respond_to :json

  def show
    @user = current_user
    respond_to do |format|
      format.html
      format.json { render json: @user, serializer: UserSerializer }
    end
  end

end
