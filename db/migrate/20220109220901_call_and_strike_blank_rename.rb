class CallAndStrikeBlankRename < ActiveRecord::Migration[6.0]
  def up
    execute "UPDATE eventdates SET striketype = 'blank_strike' WHERE striketype = 'blank'"
    execute "UPDATE eventdates SET calltype = 'blank_call' WHERE calltype = 'blank';"
    change_column :eventdates, :calltype, :string, default: "blank_call"
    puts "Trust me, it didn't run this migration correctly. Go to the SQL console and run:"
    puts "UPDATE eventdates SET striketype = 'blank_strike' WHERE striketype = 'blank';"
    puts "UPDATE eventdates SET calltype = 'blank_call' WHERE calltype = 'blank';"
  end

  def down
    execute "UPDATE eventdates SET striketype = 'blank' WHERE striketype = 'blank_strike';"
    execute "UPDATE eventdates SET calltype = 'blank' WHERE calltype = 'blank_call';"
    change_column :eventdates, :calltype, :string, default: "blank"
    puts "Trust me, it didn't run this migration correctly. Go to the SQL console and run:"
    puts "UPDATE eventdates SET striketype = 'blank' WHERE striketype = 'blank_strike';"
    puts "UPDATE eventdates SET calltype = 'blank' WHERE calltype = 'blank_call';"
  end
end
