class EmailsController < ApplicationController
  skip_before_action :authenticate_member!, :only => [:create]
  load_and_authorize_resource only: [:index, :show, :update, :sent, :unread]
  protect_from_forgery except: :create
  
  def index
    @emails = @emails.received.paginate(:per_page => 20, :page => params[:page])
    @title = "Emails"
  end
  
  def sent
    @emails = @emails.sent.paginate(:per_page => 20, :page => params[:page])
    @title = "Send Emails"
  end
  
  def unread
    @emails = @emails.unread.paginate(:per_page => 20, :page => params[:page])
    @title = "Unread Emails"
  end
  
  def reply
    @reply = Email.find(params[:id]).reply(current_member)
  end
  
  def send_reply
    @email = Email.new(params.require(:email).permit(:sender, :recipient, :cc, :bcc, :subject, :contents, :in_reply_to))
    authorize! :create, @email
    
    unless can? :sender, Email
      @email.sender = current_member.email
    end
    
    reply = EmailMailer.reply(@email).deliver_now
    @email.message_id = reply.message_id
    @email.timestamp = reply.date
    @email.sent = true
    @email.headers = reply.header.to_s
    
    replied = Email.where(message_id: @email.in_reply_to).first
    @email.event = replied.event
    
    @email.save
    
    flash[:notice] = "Successfully responded to email."
    
    if can? :show, replied
      redirect_to replied
    else
      redirect_to replied.event
    end
  end
  
  def new_event
    @email = Email.find(params[:id])
    authorize! :manage, @email
    
    @event = Event.new(title: @email.subject, created_email: @email.id)
    
    @event.contactemail = @email.sender
    if @email.contents =~ /from:.*\((.*)\)/
      @event.contact_name = $1
    end
    
    if @email.contents =~ /\s(\(?\d{3}\)?\D\d{3}\D\d{4})\s/
      @event.contact_phone = $1
    end
  end
  
  def existing_event
    @email = Email.find(params[:id])
    authorize! :manage, @email
    
    @subjectMatches = []
    @email.subject.split(" ").each do |word|
      matches = Event.current_year.where("title LIKE (?)", "%#{word}%").order(representative_date: :desc)
      unless matches.empty?
        @subjectMatches << [word, matches]
      end
    end
    
    @senderMatches = Event.current_year.where("contactemail LIKE (?)", @email.sender).order(representative_date: :desc)
    @recentEvents = Event.current_year.order(representative_date: :desc)
  end
  
  def show
    @title = "Viewing Email #{@email.subject}"
    @email.unread = false
    @email.save
    
    @newerEmail = Email.where("timestamp > (?)", @email.timestamp).order(timestamp: :asc).limit(1).first
    @olderEmail = Email.where("timestamp < (?)", @email.timestamp).order(timestamp: :desc).limit(1).first
    @newerUnreadEmail = Email.where("timestamp > (?) AND unread = true", @email.timestamp).order(timestamp: :asc).limit(1).first
    @olderUnreadEmail = Email.where("timestamp < (?) AND unread = true", @email.timestamp).order(timestamp: :desc).limit(1).first
  end
  
  def update
    error = false
    
    begin
      @email.update(params.require(:email).permit(:unread, :event_id))
    rescue
      error = true
    end
    
    respond_to do |format|
      format.html do
        if error
          flash[:error] = "There was an error updating the email."
        else
          flash[:notice] = "Email updated successfully."
        end
        
        redirect_to @email
      end
      
      format.json do
        render json: { message: "Email updated." }
      end
    end
  end
  
  def weekly
    @title = "Send Weekly Email"
    @eventdates = Eventdate.where(startdate: DateTime.current.beginning_of_day..(DateTime.current.beginning_of_day + 7.days))
  end
  
  def send_weekly
    EmailMailer.weekly_events(current_member, params[:to], params[:bcc], params[:subject], params[:body]).deliver_now
    
    flash[:notice] = "Email Sent"
    respond_to do |format|
      format.html {redirect_to weekly_emails_url}
    end
  end
  
end
