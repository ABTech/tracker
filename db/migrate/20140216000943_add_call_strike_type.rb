class AddCallStrikeType < ActiveRecord::Migration
  def up
    add_column :eventdates, :calltype, :string, :null => false
    add_column :eventdates, :striketype, :string, :null => false
    
    Eventdate.all.each do |ed|
      if ed.calldate.nil?
        ed.update_column(:calltype, "blank")
      else
        ed.update_column(:calltype, "literal")
      end
      
      if ed.strikedate.nil?
        ed.update_column(:striketype, "blank")
      elsif ed.strikedate == ed.enddate
        ed.update_column(:striketype, "enddate")
      else
        ed.update_column(:striketype, "literal")
      end
    end
  end
  
  def down
    remove_column :eventdates, :calltype
    remove_column :eventdates, :striketype
  end
end
