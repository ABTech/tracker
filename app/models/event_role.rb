class EventRole < ApplicationRecord
  belongs_to :roleable, polymorphic: true
  belongs_to :member, optional: true
  has_many :applications, class_name: "EventRoleApplication", :dependent => :destroy

  Role_HoT        = "HoT"
  Role_sTiC       = "sTiC"
  Role_TiC        = "TiC"
  Role_aTiC       = "aTiC"
  Role_sFoH       = "sFoH"
  Role_FoH        = "FoH"
  Role_aFoH       = "aFoH"
  Role_sMon       = "sMon"
  Role_Mon        = "Mon"
  Role_aMon       = "aMon"
  Role_sSD        = "sSD"
  Role_SD         = "SD"
  Role_aSD        = "aSD"
  Role_sLD        = "sLD"
  Role_LD         = "LD"
  Role_aLD        = "aLD"
  Role_Lprog      = "Lprog"
  Role_sME        = "sME"
  Role_ME         = "ME"
  Role_aME        = "aME"
  Role_sMR        = "sMR"
  Role_MR         = "MR"
  Role_aMR        = "aMR"
  Role_sSM        = "sSM"
  Role_SM         = "SM"
  Role_aSM        = "aSM"
  Role_bdSM       = "bdSM"
  Role_sMedia     = "sMedia"
  Role_Media      = "Media"
  Role_aMedia     = "aMedia"
  Role_SpotOp     = "SpotOp"
  Role_Runner     = "Runner"
  Role_sHole      = "sHole"
  Role_Hole       = "Hole"
  Role_aHole      = "aHole"
  Role_sCar       = "sCar"
  Role_car        = "car"
  Role_sTruck     = "sTruck"
  Role_truck      = "truck"
  Role_setup      = "setup"
  Role_strike     = "strike"
  Role_attend     = "attend"
  Role_food       = "food"
  Role_sairhorn   = "sAirhorn"
  Role_airhorn    = "airhorn"
  Role_aairhorn   = "aAirhorn"
  Role_cannon     = "cannon"
    
  #Roles_all is also used for ordering roles (sorting)
  Roles_All = [
    Role_HoT      ,
    Role_sTiC     ,
    Role_TiC      ,
    Role_aTiC     ,
    Role_sFoH     ,
    Role_FoH      ,
    Role_aFoH     ,
    Role_sMon     ,
    Role_Mon      ,
    Role_aMon     ,
    Role_sSD      ,
    Role_SD       ,
    Role_aSD      ,
    Role_sLD      ,
    Role_LD       ,
    Role_aLD      ,
    Role_Lprog    ,
    Role_sME      ,
    Role_ME       ,
    Role_aME      ,
    Role_sMR      ,
    Role_MR       ,
    Role_aMR      ,
    Role_sSM      ,
    Role_SM       ,
    Role_aSM      ,
    Role_bdSM     ,
    Role_sMedia   ,
    Role_Media    ,
    Role_aMedia   ,
    Role_SpotOp   ,
    Role_Runner   ,
    Role_sHole    ,
    Role_Hole     ,
    Role_aHole    ,
    Role_sCar     ,
    Role_car      ,
    Role_sTruck   ,
    Role_truck    ,
    Role_setup    ,
    Role_strike   ,
    Role_attend   ,
    Role_food     ,
    Role_sairhorn ,
    Role_airhorn  ,
    Role_aairhorn ,
    Role_cannon   ]

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
        if options[:use_both_names]
          "#{member.display_name} (#{member.fullname})"
        else
          member.display_name
        end
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
    return [Role_TiC, Role_aTiC] if self.role == Role_sTiC
    return [Role_aTiC] if self.role == Role_TiC
    return [Role_FoH, Role_aFoH] if self.role == Role_sFoH
    return [Role_aFoH] if self.role == Role_FoH
    return [Role_Mon, Role_aMon] if self.role == Role_sMon
    return [Role_aMon] if self.role == Role_Mon
    return [Role_SD, Role_aSD] if self.role == Role_sSD
    return [Role_aSD] if self.role == Role_SD
    return [Role_LD, Role_aLD, Role_Lprog] if self.role == Role_sLD
    return [Role_aLD, Role_Lprog] if self.role == Role_LD
    return [Role_ME, Role_aME] if self.role == Role_sME
    return [Role_aME] if self.role == Role_ME
    return [Role_MR, Role_aMR] if self.role == Role_sMR
    return [Role_aMR] if self.role == Role_MR
    return [Role_SM, Role_aSM, Role_bdSM] if self.role == Role_sSM
    return [Role_aSM, Role_bdSM] if self.role == Role_SM
    return [Role_Media, Role_aMedia] if self.role == Role_sMedia
    return [Role_aMedia] if self.role == Role_Media
    return [Role_Hole, Role_aHole] if self.role == Role_sHole
    return [Role_aHole] if self.role == Role_Hole
    return [Role_car] if self.role == Role_sCar
    return [Role_truck] if self.role == Role_sTruck
    return [Role_airhorn, Role_aairhorn] if self.role == Role_sairhorn
    return [Role_aairhorn] if self.role == Role_airhorn
    return []
  end
  
  def shoulders
    return [Role_sTiC] if self.role == Role_TiC or self.role == Role_aTiC
    return [Role_sFoH] if self.role == Role_FoH or self.role == Role_aFoH
    return [Role_sMon] if self.role == Role_Mon or self.role == Role_aMon
    return [Role_sSD] if self.role == Role_SD or self.role == Role_aSD
    return [Role_sLD] if self.role == Role_LD or self.role == Role_aLD or self.role == Role_Lprog
    return [Role_sME] if self.role == Role_ME or self.role == Role_aME
    return [Role_sMR] if self.role == Role_MR or self.role == Role_aMR
    return [Role_sSM] if self.role == Role_SM or self.role == Role_aSM or self.role == Role_bdSM
    return [Role_sMedia] if self.role == Role_Media or self.role == Role_aMedia
    return [Role_sHole] if self.role == Role_Hole or self.role == Role_aHole
    return [Role_sCar] if self.role == Role_car
    return [Role_sTruck] if self.role == Role_truck
    return [Role_sairhorn] if self.role == Role_airhorn or self.role == Role_aairhorn
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
    return nil if self.role == Role_sTiC
    return [Role_sTiC] if self.role == Role_TiC
    # aTiC covered by default case at end of method
    return [Role_sFoH] if self.role == Role_FoH
    return [Role_sFoH, Role_FoH] if self.role == Role_aFoH
    return [Role_sMon] if self.role == Role_Mon
    return [Role_sMon, Role_Mon] if self.role == Role_aMon
    return [Role_sSD] if self.role == Role_SD
    return [Role_sSD, Role_SD] if self.role == Role_aSD
    return [Role_sLD] if self.role == Role_LD
    return [Role_sLD, Role_LD] if self.role == Role_aLD or self.role == Role_Lprog
    return [Role_sME] if self.role == Role_ME
    return [Role_sME, Role_ME] if self.role == Role_aME
    return [Role_sMR] if self.role == Role_MR
    return [Role_sMR, Role_MR] if self.role == Role_aMR
    return [Role_sSM] if self.role == Role_SM
    return [Role_sSM, Role_SM] if self.role == Role_aSM or self.role == Role_bdSM
    return [Role_sMedia] if self.role == Role_Media
    return [Role_sMedia, Role_Media] if self.role == Role_aMedia
    return [Role_sHole] if self.role == Role_Hole
    return [Role_sHole, Role_Hole] if self.role == Role_aHole
    return [Role_sCar] if self.role == Role_car
    return [Role_sTruck] if self.role == Role_truck
    return [Role_sairhorn] if self.role == Role_airhorn
    return [Role_sairhorn, Role_airhorn] if self.role == Role_aairhorn
    return [Role_sTiC, Role_TiC]
  end
end
