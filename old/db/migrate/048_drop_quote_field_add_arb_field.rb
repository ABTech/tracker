class DropQuoteFieldAddArbField < ActiveRecord::Migration
  def self.up
    add_column("events", "arb_member_id", :integer);
    remove_column("events", "price_quote");

    me = Member.find_by_kerbid("saagarp@andrew.cmu.edu").id;
    Event.find(:all).each do |evt|
        evt.arb_member_id = me;
        evt.save();
    end
  end

  def self.down
    remove_column("events", "arb_member_id");
    add_column("events", "price_quote", :integer);
  end
end
