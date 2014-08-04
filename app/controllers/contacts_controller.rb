class ContactsController < ApplicationController

  before_filter :authenticate!
  respond_to :json

  def index
    logger.debug  current_user.contacts.as_json
    render json: current_user.contacts.as_json
  end


  def sync
    current_user.sync_contacts
    render json: current_user.contacts.as_json
  end


end
