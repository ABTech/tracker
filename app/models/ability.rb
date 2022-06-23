class Ability
  include CanCan::Ability

  def initialize(member)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    
    member ||= Member.new(:role => :suspended)

    can :index, Event
    can :eventrequest, Event

    if not member.suspended?
      can :read, Event
      can :index, Member
      can :update, Member, :id => member.id
      can :read, Organization
      can :read, Attachment
      can :tshirts, Member
      can :roles, Member
      can :index, WeatherController
    end
    
    if member.is_at_least? :general_member
      can :create, Comment, :member_id => member.id
      can :destroy, Comment, :member_id => member.id
      can :manage, TimecardEntry, :member_id => member.id
      can :show, Timecard 
      can :create, Email
      
      can :tic, Event do |event|
        event.tic.include? member
      end
      
      can :update, Event do |event|
        event.has_run_position? member or event.eventdates.any? {|ed| ed.has_run_position? member}
      end
      
      can :tic, Eventdate do |ed|
        (!ed.event.nil? and ed.event.tic.include? member) or ed.tic.include? member
      end
      
      can :update, Email do |email|
        !email.event.nil? and (email.event.has_run_position? member or email.event.eventdates.any? {|ed| ed.has_run_position? member})
      end
      
      can :read, Invoice, :event_id => member.event_roles.pluck(:roleable_id)
      can :readprice, Invoice, :event_id => member.event_roles.where(role: EventRole::Role_TiC, roleable_type: "Event").pluck(:roleable_id)
      
      can :create, EventRoleApplication, :member_id => member.id
      can :withdraw, EventRoleApplication, :member_id => member.id
      can :update, EventRoleApplication do |app|
        app.event_role.event.tic.include? member or app.event_role.roleable.run_positions_for(member).map(&:assistants).flatten.include? app.event_role.role
      end
    end
    
    if member.is_at_least? :exec
      # Almost read only finance
      can :read, :finance
      can :read, Invoice
      can :readprice, Invoice
      can :create, Invoice
      can :update, Invoice, :status => Invoice::Invoice_Status_Group_Exec
      can :email, Invoice, :status => Invoice::Invoice_Status_Group_Exec
      can :read, InvoiceItem
      can [:read, :view], Timecard
      
      # Event Management
      can :manage, Event
      can :manage, Eventdate
      cannot :update_textable_social, Event
      can :manage, Email
      can :sender, Email
      can :destroy, Comment
      can :manage, Blackout
      can :update, EventRoleApplication
      can :supertic, Event
      can :supertic, Eventdate
      
      # Manage equipment
      can :manage, Equipment

      # Read only tracker management
      can :read, Location
      can :read, EmailForm

      # Delegated member creation
      can :create, Member
    end
    
    if member.is_at_least? :tracker_management
      can [:create, :read, :update, :destroy, :payrate], Member
      can :manage, :finance
      can :manage, Invoice
      can :manage, InvoiceItem
      can :manage, Location
      can :manage, Organization
      can :manage, EmailForm
      can :manage, Attachment
      can :manage, SuperTic
      can :read, Kiosk
    end
    
    cannot :destroy, Event
    
    if member.head_of_tech?
      can :manage, Timecard
      can :manage, Member
      can :update_textable_social, Event
      can :lock, Kiosk
    end
    
    if member.tracker_dev?
      can :manage, :all
      can :update_textable_social, Event
    end
  end
end
