# == Schema Information
# Schema version: 78
#
# Table name: email_forms
#
#  id          :integer(11)     not null, primary key
#  description :string(255)     default(""), not null
#  contents    :text            default(""), not null
#

class EmailForm < ActiveRecord::Base
    validates_presence_of :description, :contents;
end
