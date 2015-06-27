# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  venmo_id                :string(255)
#  username                :string(255)
#  first_name              :string(255)
#  last_name               :string(255)
#  email                   :string(255)
#  phone                   :string(255)
#  access_token            :string(255)
#  access_token_expires_at :datetime
#  refresh_token           :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :first_name, :last_name, :email, :phone
end     


