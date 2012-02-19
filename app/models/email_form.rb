# == Schema Information
# Schema version: 80
#
# Table name: email_forms
#
#  id          :integer(11)     not null, primary key
#  description :string(255)     not null
#  contents    :text            not null
#

class EmailForm < ActiveRecord::Base
    validates_presence_of :description, :contents;
end
