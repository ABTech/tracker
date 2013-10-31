class AddMoreDetailsToMember < ActiveRecord::Migration
  def self.up
    add_column :members, :callsign, :string
    add_column :members, :shirt_size, :string, :limit => 20
  end

  def self.down
    remove_column :members, :callsign
    remove_column :members, :shirt_size
  end
end
