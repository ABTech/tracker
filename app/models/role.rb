# == Schema Information
# Schema version: 78
#
# Table name: roles
#
#  id   :integer(10)     not null, primary key
#  name :string(40)      default(""), not null
#  info :string(80)      default(""), not null
#

# See <a href="http://wiki.rubyonrails.com/rails/show/AccessControlListExample">http://wiki.rubyonrails.com/rails/show/AccessControlListExample</a>
# and <a href="http://wiki.rubyonrails.com/rails/show/LoginGeneratorAccessControlList">http://wiki.rubyonrails.com/rails/show/LoginGeneratorAccessControlList</a>

class Role < ActiveRecord::Base
  has_and_belongs_to_many :permissions
  has_and_belongs_to_many :members
end
