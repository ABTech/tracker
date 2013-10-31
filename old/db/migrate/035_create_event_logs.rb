class CreateEventLogs < ActiveRecord::Migration
  def self.up
    create_table :event_logs do |t|
        t.column :event_id, :integer;
        t.column :member_id, :integer;
        t.column :time, :float;
        t.column :call_participation, :boolean;
        t.column :show_participation, :boolean;
        t.column :strike_participation, :boolean;
    end
  end

  def self.down
    drop_table :event_logs
  end
end
