# == Schema Information
#
# Table name: emails
#
#  id         :integer          not null, primary key
#  event_id   :integer          not null
#  sender     :string(255)      default(""), not null
#  timestamp  :datetime         not null
#  contents   :text             default(""), not null
#  status     :string(255)      default("New"), not null
#  subject    :string(255)
#  message_id :string(255)      not null
#

class Email < ActiveRecord::Base
  belongs_to :event;
  
  Email_Status_Unfiled  = "Unfiled";
  Email_Status_New      = "New";
  Email_Status_Read     = "Read";
  Email_Status_Ignored  = "Ignored";
  
  Email_Status_Group_New = [Email_Status_Unfiled,
                            Email_Status_New];
  Email_Status_Group_All = [Email_Status_Unfiled,
                            Email_Status_New,
                            Email_Status_Read,
                            Email_Status_Ignored];
    
  validates_presence_of :sender, :timestamp, :contents, :status; #:contactemail
  validates_inclusion_of :status, :in => Email_Status_Group_All;
  validates_format_of :sender, :with => Event::EmailRegex;

    def headerless_contents
        segments = contents.split(/\n[\r]*\n/);
        contents = segments[2, segments.size()].join("\n\n");

        # try to find any "reply" segments, and parse them away
        # prereply = contents.split(/[-> ]*On.*wrote:.*$/, 2)[0];
        # if(prereply)
            # return prereply
        # else
            # return "";
        # end
    end

    def subject
      if read_attribute(:subject).nil?
        return ""
      else
        read_attribute(:subject)
      end
    end
end
