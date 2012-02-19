# == Schema Information
# Schema version: 80
#
# Table name: bugs
#
#  id           :integer(11)     not null, primary key
#  member_id    :integer(11)
#  submitted_on :datetime
#  description  :text            not null
#  confirmed    :boolean(1)      not null
#  resolved     :boolean(1)      not null
#  resolved_on  :datetime
#  comment      :text
#  closed       :boolean(1)      not null
#  priority     :string(255)
#  created_on   :datetime
#  updated_on   :datetime
#

class Bug < ActiveRecord::Base
  #  MODEL for future reference
  #  CREATE TABLE `abtechtt_prod`.`bugs` (
  #  `id` int( 11 ) NOT NULL AUTO_INCREMENT ,
  #  `member_id` int( 11 ) default NULL ,
  #  `submitted_on` datetime default NULL ,
  #  `description` text NOT NULL ,
  #  `confirmed` tinyint( 1 ) NOT NULL default '0',
  #  `resolved` tinyint( 1 ) NOT NULL default '0',
  #  `resolved_on` datetime default NULL ,
  #  `comment` text,
  #  `closed` tinyint( 1 ) NOT NULL default '0',
  #  `priority` varchar( 255 ) default NULL ,
  #  `created_on` datetime default NULL ,
  #  `updated_on` datetime default NULL ,
  #  PRIMARY KEY ( `id` )
  #  ) ENGINE = MYISAM DEFAULT CHARSET = utf8;

  belongs_to :member
  validates_presence_of :description, :member

  def self.count_open
    self.count :conditions => 'closed != 1'
  end

end
