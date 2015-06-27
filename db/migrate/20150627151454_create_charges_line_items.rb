class CreateChargesLineItems < ActiveRecord::Migration
  def change
    create_join_table :charges, :line_items
  end
end
