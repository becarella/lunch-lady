class LineItemsController < ApplicationController

  def update
    update_attr = params[:line_item].whitelist(:charge_to_nickname, :charge_to_venmo)
    line_item = current_user.line_items.find(params[:id])
    line_item.update_attributes(update_attr)
    render json: line_item, serializer: LineItemSerializer
  end

end
