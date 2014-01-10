class EquipmentEventdate < ActiveRecord::Base
  belongs_to :eventdate
  belongs_to :equipment
end
