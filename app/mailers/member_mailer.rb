class MemberMailer < ActionMailer::Base

  def comment(member, comment)
    @member = member
    @comment = comment

    mail to: member.email, from: "no-reply@tracker.abtech.org", subject: "New Comment on #{comment.event.title}"
  end
  
end
