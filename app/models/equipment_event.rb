class EquipmentEvent < ActiveRecord::Base
  belongs_to :equipment
  belongs_to :event
  belongs_to :eventdate_start, class_name: "Eventdate"
  belongs_to :eventdate_end, class_name: "Eventdate"
end
