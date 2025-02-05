class AddFulltextIndexToEventsAndEventDates < ActiveRecord::Migration[6.1]
  def up
    execute "ALTER TABLE events ADD FULLTEXT INDEX fulltext_index_events (title);"
    execute "ALTER TABLE eventdates ADD FULLTEXT INDEX fulltext_index_eventdates (description);"
  end
  
  def down
    execute "ALTER TABLE events DROP INDEX fulltext_index_events"
    execute "ALTER TABLE eventdates DROP INDEX fulltext_index_eventdates"
  end
end
