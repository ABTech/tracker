class ForceGenerateLastRepresentativeDateOnEvents < ActiveRecord::Migration[6.1]
  def up
    Event.where("last_representative_date IS ?", nil).find_each do |event|
      event.save
    end
  end
  def down
    # Nothing
  end
end
