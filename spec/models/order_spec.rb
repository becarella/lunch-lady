# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  site          :string(255)
#  original_text :text
#  restaurant    :string(255)
#  order_number  :string(255)
#  total         :float            default(0.0)
#  tip           :float            default(0.0)
#  tax           :float            default(0.0)
#  created_at    :datetime
#  updated_at    :datetime
#  discount      :float            default(0.0)
#  delivery      :float            default(0.0)
#  subtotal      :float            default(0.0)
#

require "rails_helper"

describe Order do

end
