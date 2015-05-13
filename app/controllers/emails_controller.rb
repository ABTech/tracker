class EmailsController < ApplicationController
  skip_before_filter :authenticate_member!, :only => [:create]
  load_and_authorize_resource only: [:index, :show, :update, :sent, :unread]
  protect_from_forgery except: :create
  
  def index
    @emails = @emails.received.paginate(:per_page => 20, :page => params[:page])
  end
  
  def sent
    @emails = @emails.sent.paginate(:per_page => 20, :page => params[:page])
  end
  
  def unread
    @emails = @emails.unread.paginate(:per_page => 20, :page => params[:page])
  end
  
  def reply
    @reply = Email.find(params[:id]).reply
  end
  
  def send_reply
    @email = Email.new(params.require(:email).permit(:sender, :recipient, :cc, :bcc, :subject, :contents, :in_reply_to))
    reply = EmailMailer.reply(@email).deliver_now
    @email.message_id = reply.message_id
    @email.timestamp = reply.date
    @email.sent = true
    @email.headers = reply.header.to_s
    
    replied = Email.where(message_id: @email.in_reply_to).first
    @email.event = replied.email
    
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
    
    @subjectMatches = []
    @email.subject.split(" ").each do |word|
      matches = Event.where("title LIKE (?)", "%#{word}%").order(representative_date: :desc)
      unless matches.empty?
        @subjectMatches << [word, matches]
      end
    end
    
    @senderMatches = Event.where("contactemail LIKE (?)", @email.sender).order(representative_date: :desc)
    @recentEvents = Event.where("representative_date >= ?", Account.magic_date).order(representative_date: :desc)
  end
  
  def show
    @email.unread = false
    @email.save
  end
  
  def create
    request.headers["HTTP_AUTHORIZATION"]
    maildropConfig = YAML::load(File.read(Rails.root.join("config","mail_room.cfg")))
    unless request.headers["HTTP_AUTHORIZATION"] == "Token token=\"#{maildropConfig[:mailboxes][0][:delivery_token]}\""
      raise CanCan::AccessDenied
    end
    
    mail = Mail.read_from_string(request.body.read)
    Email.create_from_mail(mail)
  end
  
  def update
    begin
      @email.update(params.require(:email).permit(:unread, :event_id))
    rescue
      flash[:error] = "There was an error updating the email."
    end
    
    redirect_to @email
  end
  
  def weekly
    @title = "Send Weekly Email"
    @eventdates = Eventdate.where(startdate: DateTime.current.beginning_of_day..(DateTime.current.beginning_of_day + 7.days))
  end
  
  def send_weekly
    @eventdates = Eventdate.where(startdate: DateTime.current.beginning_of_day..(DateTime.current.beginning_of_day + 7.days)).to_a
    @eventdates.select! { |eventdate| params["eventdate_include" + eventdate.id.to_s] == "1" }
    
    @eventdates.each do |eventdate|
      eventdate.email_description = params["eventdate_description" + eventdate.id.to_s]
      eventdate.save
    end
    
    EmailMailer.weekly_events(current_member, params[:to], params[:bcc], params[:subject], params[:intro_blurb], params[:outro_blurb], @eventdates).deliver_now
    
    flash[:notice] = "Email Sent"
    respond_to do |format|
      format.html {redirect_to weekly_email_index_url}
    end
  end
  
end
