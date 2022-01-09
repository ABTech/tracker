class CallAndStrikeBlankRename < ActiveRecord::Migration[6.0]
  def up
    execute "UPDATE eventdates SET striketype = 'blank_strike' WHERE striketype = 'blank'"
    execute "UPDATE eventdates SET calltype = 'blank_call' WHERE calltype = 'blank';"
    change_column :eventdates, :calltype, :string, default: "blank_call"
  end

  def down
    execute "UPDATE eventdates SET striketype = 'blank' WHERE striketype = 'blank_strike';"
    execute "UPDATE eventdates SET calltype = 'blank' WHERE calltype = 'blank_call';"
    change_column :eventdates, :calltype, :string, default: "blank"
  end
end
