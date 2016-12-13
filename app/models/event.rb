class Event < ActiveRecord::Base
  belongs_to :organization
  has_many :emails
  has_many :eventdates, -> { order "startdate ASC" }, :dependent => :destroy
  has_many :event_roles, :as => :roleable, :dependent => :destroy
  has_many :invoices, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :attachments, as: :attachable
  has_one :blackout, :dependent => :destroy
  
  amoeba do
    include_association [:eventdates, :event_roles]
  end
  
  accepts_nested_attributes_for :eventdates, :allow_destroy => true
  accepts_nested_attributes_for :event_roles, :allow_destroy => true
  accepts_nested_attributes_for :attachments, :allow_destroy => true
  accepts_nested_attributes_for :invoices
  accepts_nested_attributes_for :blackout, :allow_destroy => true
  
  attr_accessor :org_type, :org_new, :created_email
  
  before_validation :prune_attachments, :prune_roles
  before_save :handle_organization, :ensure_tic, :sort_roles, :synchronize_representative_date
  after_initialize :default_values
  after_save :set_eventdate_delta_flags, :set_created_email
  
  EmailRegex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  PhoneRegex = /\A[0-9]{3}-[0-9]{3}-[0-9]{4}\z/
  
  Event_Status_Tentative_Date     = "Tentative Date"
  Event_Status_Initial_Request    = "Initial Request"
  Event_Status_Details_Requested  = "Details Requested"
  Event_Status_Quote_Sent         = "Quote Sent"
  Event_Status_Event_Confirmed    = "Event Confirmed"
  Event_Status_Billing_Pending	  = "Billing Pending"
  Event_Status_Event_Completed    = "Event Completed"
  Event_Status_Event_Declined     = "Event Declined"
  Event_Status_Event_Cancelled    = "Event Cancelled"
  
  Event_Status_Group_Completed = [Event_Status_Event_Completed,
                                  Event_Status_Event_Cancelled,
                                  Event_Status_Event_Declined]
  
  Event_Status_Group_All = [Event_Status_Initial_Request,
                            Event_Status_Tentative_Date,
                            Event_Status_Details_Requested,
                            Event_Status_Quote_Sent,
                            Event_Status_Event_Confirmed,
                            Event_Status_Billing_Pending,
                            Event_Status_Event_Completed,
                            Event_Status_Event_Declined,
                            Event_Status_Event_Cancelled]

  Event_Status_Group_Not_Cancelled = [Event_Status_Tentative_Date,
                            Event_Status_Initial_Request,
                            Event_Status_Details_Requested,
                            Event_Status_Quote_Sent,
                            Event_Status_Event_Confirmed,
			                      Event_Status_Billing_Pending,
                            Event_Status_Event_Completed]

  Event_Status_Group_Cancelled = [Event_Status_Event_Cancelled]

  Event_Status_Group_Declined  = [Event_Status_Event_Declined]

  validates_presence_of     :title, :status, :organization, :eventdates
  validates_inclusion_of    :status, :in => Event_Status_Group_All
  validates_associated      :organization, :emails, :event_roles, :eventdates
  validates_format_of       :contactemail, :with => Event::EmailRegex, :multiline => true
  
  scope :current_year, -> { where("representative_date >= ?", Account.magic_date) }

  def locations
    eventdates.flat_map(&:locations).uniq.sort_by(&:id)
  end

  # return an array of dates segmenting regions of dates.
  def date_regions
    times = eventdates.collect{|dt| [dt.startdate, dt.enddate]}.flatten().uniq().sort();
    dates = eventdates().sort_by{|k| k.startdate};

    contents = [];
    working_set = [];
    headers = [];

    times.each do |time|
      working_set.reject! {|date| !((date.startdate <= time) && (date.enddate > time))};

      while(!dates.empty? && (dates.first.startdate <= time) && (dates.first.enddate > time))
        working_set << dates.shift();
      end
    
      if(!working_set.empty?)
        headers << time;
        contents << Array.new(working_set);
      end
    end

    return headers, contents;
  end

  # method to resort event_roles by a given key
  # @param by is a field of event_role, but this behavior is not yet implemented
  def sort_roles
    event_roles.to_a.sort!
  end

  def to_s
    self.title
  end

  def members
    @members or @members = event_roles.inject(Array.new) do |uniq_roles, er| 
      ( uniq_roles << er.member unless er.member.nil? or uniq_roles.any? { |ur| ur.id == er.member_id } ) or uniq_roles 
    end
  end
    
  def total_payroll
    eventdates.map(&:total_gross).reduce(0.0, &:+)
  end
  
  def tic
    event_roles.where(role: [EventRole::Role_TiC, EventRole::Role_aTiC]).where.not(member: nil).all.map(&:member)
  end
  
  def exec
    role = event_roles.where(role: EventRole::Role_exec).first
    return role.member if role
    return nil
  end
  
  def synchronize_representative_date
    self.representative_date = self.eventdates[0].startdate
  end
  
  def has_run_position?(member)
    self.event_roles.where(member: member).count > 0
  end
  
  def run_positions_for(member)
    self.event_roles.where(member: member)
  end
  
  def techies
    self.event_roles.includes(:member).map(&:member).uniq.compact
  end
  
  def all_techies
    (self.eventdates.includes(event_roles: [:member]).map(&:event_roles).flatten.map(&:member) +
    self.event_roles.includes(:member).map(&:member)).uniq.compact
  end
  
  def eventdates_editable_by(member)
    if member.ability.can? :tic, self
      self.eventdates
    else
      self.eventdates.select do |ed|
        ed.has_run_position? member
      end
    end
  end
  
  def has_editable_eventdates?(member)
    eventdates_editable_by(member).count != 0
  end

  def current_year?
    representative_date >= Account.magic_date
  end
    
  private
    def handle_organization
      if self.org_type == "new"
        self.organization = Organization.create(:name => org_new)
      end
    end
    
    def ensure_tic
      if not self.event_roles.any? { |role| role.role == EventRole::Role_TiC }
        rl = EventRole.new
        rl.role = EventRole::Role_TiC
        self.event_roles << rl
      end
    end
    
    def prune_attachments
      self.attachments = self.attachments.reject { |a| a.attachment.blank? }
    end
    
    def prune_roles
      self.event_roles = self.event_roles.reject { |er| er.role.blank? }
    end
    
    def default_values
      if self.new_record?
        if self.eventdates.size == 0
          dt = Eventdate.new
          dt.calldate = Time.now
          dt.startdate = Time.now
          dt.enddate = Time.now
          dt.strikedate = Time.now
          dt.event_roles << EventRole.new
          self.eventdates << dt
        end
        
        if self.event_roles.size == 0
          rl = EventRole.new
          rl.role = EventRole::Role_TiC
          self.event_roles << rl
        end
      end
    end
    
    def set_eventdate_delta_flags
      eventdates.each do |eventdate|
        eventdate.delta = true
        eventdate.save
      end
    end
    
    def set_created_email
      unless created_email.nil? or created_email.empty?
        mail = Email.find(created_email)
        mail.event = self
        mail.save
      end
    end
end
