class Email < ActiveRecord::Base
  belongs_to :event

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
  validates_format_of :sender, :with => Event::EmailRegex, :multiline => true;

  def headerless_contents
    segments = contents.split(/\n[\r]*\n/);
    contents = segments[2, segments.size()].join("\n\n");
  end

  def subject
    if read_attribute(:subject).nil?
      return ""
    else
      read_attribute(:subject)
    end
  end
end
