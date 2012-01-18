# == Schema Information
# Schema version: 93
#
# Table name: event_roles
#
#  id        :integer(11)     not null, primary key
#  event_id  :integer(11)     not null
#  member_id :integer(11)     not null
#  role      :string(255)     not null
#

class EventRole < ActiveRecord::Base
    belongs_to :event;
    belongs_to :member;

    Role_HoT        = "HoT";
    Role_TIC        = "TIC";
    Role_aTIC       = "aTIC";
    Role_FoH        = "FoH";
    Role_aFoH       = "aFoH";
    Role_Mon        = "Mon";
    Role_aMon       = "aMon";
    Role_LD         = "LD";
    Role_iLD        = "iLD";
    Role_aLD        = "aLD";
    Role_iLprog     = "iLprog"
    Role_cLprog     = "cLprog"
    Role_ME         = "ME";
    Role_aME        = "aME";
    Role_MR         = "MR";
    Role_aMR        = "aMR";
    Role_SM         = "SM";
    Role_aSM        = "aSM";
    Role_bdSM       = "bdSM";
    Role_SpotOp     = "SpotOp";
    Role_Runner     = "Runner";
    Role_Hole       = "Hole";
    Role_aHole      = "aHole";
    Role_car	    = "car"
    Role_trunk      = "truck"
    Role_setup      = "setup"
    Role_strike      = "strike"
    
    #Roles_all is also used for ordering roles (sorting)
    Roles_All = [
      Role_HoT	  ,
      Role_TIC	  ,
      Role_aTIC	  ,
      Role_FoH	  ,
      Role_aFoH	  ,
      Role_Mon	  ,
      Role_aMon	  ,
      Role_LD	  ,
      Role_iLD	  ,
      Role_aLD	  ,
      Role_iLprog ,
      Role_cLprog ,
      Role_ME	  ,
      Role_aME	  ,            
      Role_MR	  ,            
      Role_aMR	  ,            
      Role_SM	  ,            
      Role_aSM	  ,            
      Role_bdSM	  ,            
      Role_SpotOp ,            
      Role_Runner ,            
      Role_Hole	  ,            
      Role_aHole  ,            
      Role_car	  ,     
      Role_trunk  ,          
      Role_setup  ,
      Role_strike
                ];

    validates_presence_of  :event, :role;
    validates_inclusion_of :role, :in => Roles_All;

    def assigned?
        return (member != nil);
    end

    def to_s
        if(assigned?)
            return role() + ": " + member.fullname;
        else
            return role() + ": (unassigned)";
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
end
