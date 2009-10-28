class StaffRecods < ActiveRecord::Migration
  def self.up
    create_table(:members) do |t| end
    add_column("members", "namefirst", :string, :null=>false);
    add_column("members", "namelast", :string, :null=>false);
    add_column("members", "kerbid", :string);
    add_column("members", "namenick", :string);
    add_column("members", "phone", :integer);
  end

  def self.down
  end
end
