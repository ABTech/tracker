class EventRole < ApplicationRecord
  belongs_to :roleable, polymorphic: true
  belongs_to :member
  has_many :applications, class_name: "EventRoleApplication", :dependent => :destroy

  Role_HoT        = "HoT"
  Role_TiC        = "TiC"
  Role_aTiC       = "aTiC"
  Role_supervise  = "supervise"
  Role_FoH        = "FoH"
  Role_aFoH       = "aFoH"
  Role_Mon        = "Mon"
  Role_aMon       = "aMon"
  Role_SD         = "SD"
  Role_aSD        = "aSD"
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
  Role_Media      = "Media"
  Role_aMedia     = "aMedia"
  Role_SpotOp     = "SpotOp"
  Role_Runner     = "Runner"
  Role_Hole       = "Hole"
  Role_aHole      = "aHole"
  Role_car        = "car"
  Role_truck      = "truck"
  Role_setup      = "setup"
  Role_strike     = "strike"
  Role_attend     = "attend"
  Role_food       = "food"
  Role_airhorn    = "airhorn"
  Role_aairhorn   = "aAirhorn"
    
  #Roles_all is also used for ordering roles (sorting)
  Roles_All = [
    Role_HoT      ,
    Role_TiC      ,
    Role_aTiC     ,
    Role_supervise,
    Role_FoH      ,
    Role_aFoH     ,
    Role_Mon      ,
    Role_aMon     ,
    Role_SD       ,
    Role_aSD      ,
    Role_LD       ,
    Role_aLD      ,
    Role_Lprog    ,
    Role_ME       ,
    Role_aME      ,            
    Role_MR       ,            
    Role_aMR      ,            
    Role_SM       ,            
    Role_aSM      ,            
    Role_bdSM     ,            
    Role_Media    ,            
    Role_aMedia   ,
    Role_SpotOp   ,            
    Role_Runner   ,            
    Role_Hole     ,            
    Role_aHole    ,            
    Role_car      ,     
    Role_truck    ,          
    Role_setup    ,
    Role_strike   ,
    Role_attend   ,
    Role_food     ,
    Role_airhorn  ,
    Role_aairhorn ]

  validates_presence_of :role
  validates_inclusion_of :role, :in => Roles_All

  def assigned?
    not member.nil?
  end

  def to_s
    role + ": " + assigned_to
  end
  
  def assigned_to(options = {})
    if assigned?
      if options[:use_display_name]
        member.display_name
      else
        member.fullname
      end
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
    return [Role_aTiC] if self.role == Role_TiC
    return [Role_aFoH] if self.role == Role_FoH
    return [Role_aMon] if self.role == Role_Mon
    return [Role_aSD] if self.role == Role_SD
    return [Role_aLD, Role_Lprog] if self.role == Role_LD
    return [Role_aME] if self.role == Role_ME
    return [Role_aMR] if self.role == Role_MR
    return [Role_aSM, Role_bdSM] if self.role == Role_SM
    return [Role_aMedia] if self.role == Role_Media
    return [Role_aHole] if self.role == Role_Hole
    return [Role_aairhorn] if self.role == Role_airhorn
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
    return nil if self.role == Role_TiC
    return Role_FoH if self.role == Role_aFoH
    return Role_Mon if self.role == Role_aMon
    return Role_SD if self.role == Role_aSD
    return Role_LD if self.role == Role_aLD or self.role == Role_Lprog
    return Role_ME if self.role == Role_aME
    return Role_MR if self.role == Role_aMR
    return Role_SM if self.role == Role_aSM or self.role == Role_bdSM
    return Role_Media if self.role == Role_aMedia
    return Role_Hole if self.role == Role_aHole
    return Role_airhorn if self.role == Role_aairhorn
    return Role_TiC
  end
end
