class Event < ActiveRecord::Base
  belongs_to :organization
  has_many :emails, -> { order "timestamp DESC" }
  has_many :eventdates, -> { order "startdate ASC" }, :dependent => :destroy
  has_many :event_roles, :dependent => :destroy
  has_many :invoices, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :journals
  has_many :attachments
  
  accepts_nested_attributes_for :eventdates, :allow_destroy => true
  accepts_nested_attributes_for :event_roles, :allow_destroy => true
  
  attr_accessor :org_type, :org_new
  
  before_save :handle_organization, :ensure_tic, :sort_roles
  after_initialize :default_values
  
  attr_accessible :title, :org_type, :organization_id, :org_new, :status, :blackout, :rental, :publish, :contact_name, :contactemail, :contact_phone, :price_quote, :notes, :eventdates_attributes, :event_roles_attributes
  
  EmailRegex = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
  PhoneRegex = /^[0-9]{3}-[0-9]{3}-[0-9]{4}$/
  
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

  Event_Status_Group_Cancelled = [Event_Status_Event_Cancelled];

  Event_Status_Group_Declined  = [Event_Status_Event_Declined];

  validates_presence_of     :title, :status, :organization, :eventdates
  validates_inclusion_of    :status, :in => Event_Status_Group_All;
  validates_associated      :organization, :emails, :event_roles, :eventdates;
  validates_format_of       :contactemail, :with => Event::EmailRegex, :multiline => true;

  def locations
    eventdates.flat_map(&:locations).uniq
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
    event_roles.sort!
  end

  def approximate_date
    return self.eventdates.first.calldate unless self.eventdates.first.nil?
  end

  def earliest_date
    return self.eventdates.collect{|ed| ed.calldate}.min unless self.eventdates.first.nil?
  end

  def to_s 
    return "#{self.title} on #{self.approximate_date.strftime('%D')}" unless self.approximate_date.nil?
    return "#{self.title}"
  end

  def members
    @members or @members = event_roles.inject(Array.new) do |uniq_roles, er| 
      ( uniq_roles << er.member unless er.member.nil? or uniq_roles.any? { |ur| ur.id == er.member_id } ) or uniq_roles 
    end
  end
  
  private
    def handle_organization
      if self.org_type == "new"
        self.organization = Organization.create(:name => org_new)
      end
    end
    
    def ensure_tic
      if not self.event_roles.any? { |role| role.role == EventRole::Role_TIC }
        rl = EventRole.new
        rl.role = EventRole::Role_TIC
        self.event_roles << rl
      end
    end
    
    def default_values
      if self.new_record?
        if self.eventdates.size == 0
          dt = Eventdate.new
          dt.calldate = Time.now
          dt.startdate = Time.now
          dt.enddate = Time.now
          dt.strikedate = Time.now
          self.eventdates << dt
        end
        
        if self.event_roles.size == 0
          rl = EventRole.new
          rl.role = EventRole::Role_TIC
          self.event_roles << rl
        end
      end
    end
end
