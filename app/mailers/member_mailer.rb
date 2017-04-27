class MemberMailer < ActionMailer::Base

  def comment(member, comment)
    @member = member
    @comment = comment

    mail to: member.email, from: "no-reply@abtech.andrew.cmu.edu", subject: "New Comment on #{comment.event.title}"
  end
  
  def new_alumni_account(member, raw_token)
    @member = member
    @raw_token = raw_token
    
    mail to: member.email, from: "no-reply@abtech.andrew.cmu.edu", subject: "An ABTech Tracker account has been created for you"
  end
  
end
