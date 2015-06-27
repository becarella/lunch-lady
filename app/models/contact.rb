# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  venmo_id   :string(255)
#  username   :string(255)
#  nickname   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Contact < ActiveRecord::Base

  def self.from_venmo venmo_user, data
    data = [data] if !data.is_a? Array
    data.each { |json| Contact.find_or_create_from_venmo(venmo_user, json) }
  end

  private 

    def self.find_or_create_from_venmo venmo_user, json
      json.stringify_keys!
      json['venmo_id'] = json.delete('id')
      contact = Contact.find_or_create_by(user_id: venmo_user.id, venmo_id: json['venmo_id'])
      json.reject! { |k,v| !Contact.column_names.include?(k.to_s) }
      contact.update_attributes(json)
      contact
    end

end
