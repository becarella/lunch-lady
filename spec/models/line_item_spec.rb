# == Schema Information
#
# Table name: line_items
#
#  id                 :integer          not null, primary key
#  order_id           :integer
#  charge_id          :integer
#  subtotal           :float            default(0.0)
#  tax                :float            default(0.0)
#  tip                :float            default(0.0)
#  delivery           :float            default(0.0)
#  discount           :float            default(0.0)
#  total              :float            default(0.0)
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
