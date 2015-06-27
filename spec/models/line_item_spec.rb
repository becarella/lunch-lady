# == Schema Information
#
# Table name: line_items
#
#  id                 :integer          not null, primary key
#  order_id           :integer
#  subtotal           :integer
#  charge_to_nickname :string(255)
#  charge_to_venmo    :string(255)
#  description        :text
#  created_at         :datetime
#  updated_at         :datetime
#

require 'rails_helper'

RSpec.describe LineItem, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
