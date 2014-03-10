ThinkingSphinx::Index.define :eventdate, :with => :active_record do
  # fields
  indexes description, :sortable => true
  indexes event.title, :as => :event
  indexes event.organization.name, :as => :organization

  has startdate
end
