ThinkingSphinx::Index.define :eventdate, :with => :active_record do
  # fields
  indexes description, :sortable => true
  indexes event.title, :as => :event
  indexes event.organization.name, :as => :organization
  indexes locations.building, :as => :location_building
  indexes locations.room, :as => :location_room

  has startdate
end
