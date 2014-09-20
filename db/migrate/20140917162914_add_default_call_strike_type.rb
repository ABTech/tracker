class AddDefaultCallStrikeType < ActiveRecord::Migration
  def up
    change_column :eventdates, :calltype, :string, null: false, default: "blank"
    change_column :eventdates, :striketype, :string, null: false, default: "enddate"
  end
  
  def down
    change_column :eventdates, :calltype, :string, null: false, default: nil
    change_column :eventdates, :striketype, :string, null: false, default: nil
  end
end
