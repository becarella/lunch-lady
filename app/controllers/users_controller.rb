class UsersController < ApplicationController

  before_filter :authenticate!
  respond_to :json

  def show
    render json: current_user
  end

end
