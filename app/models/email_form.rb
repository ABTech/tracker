# == Schema Information
#
# Table name: email_forms
#
#  id          :integer          not null, primary key
#  description :string(255)      not null
#  contents    :text             default(""), not null
#

class EmailForm < ActiveRecord::Base
    validates_presence_of :description, :contents;
end
