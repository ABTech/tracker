class EventRole < ActiveRecord::Base
  belongs_to :roleable, polymorphic: true
  belongs_to :member
  has_many :applications, class_name: "EventRoleApplication"

  Role_HoT        = "HoT"
  Role_TIC        = "TIC"
  Role_aTIC       = "aTIC"
  Role_exec       = "exec"
  Role_FoH        = "FoH"
  Role_aFoH       = "aFoH"
  Role_Mon        = "Mon"
  Role_aMon       = "aMon"
  Role_LD         = "LD"
  Role_aLD        = "aLD"
  Role_Lprog      = "Lprog"
  Role_ME         = "ME"
  Role_aME        = "aME"
  Role_MR         = "MR"
  Role_aMR        = "aMR"
  Role_SM         = "SM"
  Role_aSM        = "aSM"
  Role_bdSM       = "bdSM"
  Role_SpotOp     = "SpotOp"
  Role_Runner     = "Runner"
  Role_Hole       = "Hole"
  Role_aHole      = "aHole"
  Role_car        = "car"
  Role_trunk      = "truck"
  Role_setup      = "setup"
  Role_strike     = "strike"
  Role_food       = "food"
    
  #Roles_all is also used for ordering roles (sorting)
  Roles_All = [
    Role_HoT    ,
    Role_TIC    ,
    Role_aTIC   ,
    Role_exec   ,
    Role_FoH    ,
    Role_aFoH   ,
    Role_Mon    ,
    Role_aMon   ,
    Role_LD     ,
    Role_aLD    ,
    Role_Lprog  ,
    Role_ME     ,
    Role_aME    ,            
    Role_MR     ,            
    Role_aMR    ,            
    Role_SM     ,            
    Role_aSM    ,            
    Role_bdSM   ,            
    Role_SpotOp ,            
    Role_Runner ,            
    Role_Hole   ,            
    Role_aHole  ,            
    Role_car    ,     
    Role_trunk  ,          
    Role_setup  ,
    Role_strike ,
    Role_food   ]

  validates_presence_of :role
  validates_inclusion_of :role, :in => Roles_All

  def assigned?
    return (member != nil);
  end

  def to_s
    role + ": " + assigned_to
  end
  
  def assigned_to
    if assigned?
      member.fullname
    else
      "(unassigned)"
    end
  end

  def sort_index 
    Roles_All.each_index { |role_index| return role_index if Roles_All[role_index] == role }
    return -1 
  end

  # define the natural sorting order
  def <=> (role)
    return 1 if sort_index < 0
    return -1 if role.sort_index < 0
    return sort_index <=> role.sort_index   
  end
  
  def assistants
    return [Role_aTIC] if self.role == Role_TIC
    return [Role_aFoH] if self.role == Role_FoH
    return [Role_aMon] if self.role == Role_Mon
    return [Role_aLD, Role_Lprog] if self.role == Role_LD
    return [Role_aME] if self.role == Role_ME
    return [Role_aMR] if self.role == Role_MR
    return [Role_aSM, Role_bdSM] if self.role == Role_SM
    return [Role_aHole] if self.role == Role_Hole
    return []
  end
  
  def event
    if self.roleable_type == "Event"
      self.roleable
    elsif self.roleable_type == "Eventdate"
      self.roleable.event
    end
  end
  
  def date
    if self.roleable_type == "Event"
      self.roleable.representative_date
    elsif self.roleable_type == "Eventdate"
      self.roleable.startdate
    end
  end
  
  def description
    if self.roleable_type == "Event"
      self.roleable.title
    elsif self.roleable_type == "Eventdate"
      self.roleable.event.title + " - " + self.roleable.description
    end
  end
  
  def superior
    return nil if self.role == Role_TIC
    return Role_FoH if self.role == Role_aFoH
    return Role_Mon if self.role == Role_aMon
    return Role_LD if self.role == Role_aLD or self.role == Role_Lprog
    return Role_ME if self.role == Role_aME
    return Role_MR if self.role == Role_aMR
    return Role_SM if self.role == Role_aSM or self.role == Role_bdSM
    return Role_Hole if self.role == Role_aHole
    return Role_TIC
  end
end
