class ChangeCasingOfTiC < ActiveRecord::Migration[5.0]
  def up
    EventRole.where(role: "TIC").update_all(role: "TiC")
    EventRole.where(role: "aTIC").update_all(role: "aTiC")
  end
  
  def down
    EventRole.where(role: "TiC").update_all(role: "TIC")
    EventRole.where(role: "aTiC").update_all(role: "aTIC")
  end
end
