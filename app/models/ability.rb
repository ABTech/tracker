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
    if not member.suspended?
      can :read, Event
      can :index, Member
      can :update, Member, :id => member.id
      can :read, Organization
      can :read, Attachment
      can :tshirts, Member
    end
    
    if member.is_at_least? :general_member
      can :create, Comment, :member_id => member.id
      can :destroy, Comment, :member_id => member.id
      can :manage, TimecardEntry, :member_id => member.id
      
      can :tic, Event do |event|
        event.tic == member
      end
      
      can :update, Event do |event|
        event.has_run_position? member
      end
    end
    
    if member.is_at_least? :exec
      # Almost read only finance
      can :read, :finance
      can :read, Account
      can :read, Invoice
      can :create, Invoice
      can :update, Invoice, :status => Invoice::Invoice_Status_Group_Exec
      can :email, Invoice, :status => Invoice::Invoice_Status_Group_Exec
      can :read, Journal
      can :read, InvoiceItem
      
      # Event Management
      can :manage, Event
      can :manage, Email
      can :destroy, Comment
      
      # Read only tracker management
      can :read, Account
      can :read, Invoice
      can :read, InvoiceItem
      can :read, Journal
      can :read, Equipment
      can :read, EquipmentCategory
      can :read, Location
      can :read, EmailForm
    end
    
    if member.is_at_least? :tracker_management
      can :manage, Member
      can :manage, :finance
      can :manage, Account
      can :manage, Invoice
      can :manage, Journal
      can :manage, InvoiceItem
      can :manage, Equipment
      can :manage, EquipmentCategory
      can :manage, Location
      can :manage, Organization
      can :manage, EmailForm
      can :manage, Attachment
    end
    
    cannot :destroy, Event
    
    if member.admin?
      can :manage, :all
    end
  end
end
