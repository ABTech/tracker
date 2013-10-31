class YearSupport < ActiveRecord::Migration
  def self.up
    create_table :years do |t|
        t.column "description", :string, :null=>false;
    end

    default = Year.create(:description => "2006-2007");

    add_column(:events, :year_id, :integer, :null=>false);
    Event.find(:all).each {|k| k.year = default; k.save()};
  end

  def self.down
    drop_table :years;
    remove_column(:events, :year_id);
  end
end
