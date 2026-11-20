require 'test_helper'

class EventdateSearchTest < ActiveSupport::TestCase
  # The scaffolded fixtures in test/fixtures are out of date with the schema,
  # so these tests create their own records instead of loading them.
  self.fixture_table_names = []

  setup do
    @lighting_org = Organization.create!(name: "Lighting Society")
    @sound_org = Organization.create!(name: "Scotch'n'Soda")
    @mudge = Location.create!(building: "Mudge Hall", room: "Lounge", details: "")
    @mudge_basement = Location.create!(building: "Mudge Hall", room: "Basement", details: "")
    @cohon = Location.create!(building: "Cohon Center", room: "Rangos Ballroom", details: "")

    @spring_carnival = create_eventdate("Spring Carnival", @lighting_org, "Midway show", [@mudge, @mudge_basement], 1.day.from_now)
    @concert = create_eventdate("Fall Concert", @sound_org, "Main stage 100%_done", [@cohon], 2.days.from_now)

    @purnell = Location.create!(building: "Purnell Center", room: "Studio", details: "")
    @rm = create_eventdate("R&M Weekly", @lighting_org, "Repairs", [@purnell], 3.days.from_now)
    @spaced_rm = create_eventdate("R & M Session", @lighting_org, "Repairs", [@purnell], 4.days.from_now)
    @hyphenated = create_eventdate("Gala", @lighting_org, "Up-lighting only", [@purnell], 5.days.from_now)
    @unhyphenated = create_eventdate("Banquet", @lighting_org, "Uplighting only", [@purnell], 6.days.from_now)
  end

  test "matches each searched column case-insensitively" do
    assert_equal [@spring_carnival], search("spring carnival")
    assert_equal [@spring_carnival], search("MIDWAY")
    assert_equal [@concert], search("scotch")
    assert_equal [@concert], search("cohon")
    assert_equal [@concert], search("ballroom")
  end

  test "requires every word, in any of the columns" do
    assert_equal [@spring_carnival], search("carnival lighting mudge")
    assert_empty search("carnival cohon")
  end

  test "matches inside words" do
    assert_equal [@spring_carnival], search("arniv")
  end

  test "returns each event date once even when several locations match" do
    assert_equal [@spring_carnival], search("mudge")
  end

  test "ignores punctuation in the query and the columns" do
    assert_equal [@rm], search("r&m")
    assert_equal [@rm], search("R&M")
    assert_equal [@rm], search("rm")
    assert_equal [@hyphenated, @unhyphenated], search("uplighting")
    assert_equal [@hyphenated, @unhyphenated], search("up-lighting")
  end

  test "keeps spaces, so spaced abbreviations need separate words" do
    assert_not_includes search("r&m"), @spaced_rm
    assert_includes search("r & m"), @spaced_rm
  end

  test "treats LIKE wildcards in the query literally" do
    # As wildcards these would match every event date, not only the one that
    # contains the characters.
    assert_equal [@concert], search("100%_done")
    assert_equal [@concert], search("%")
    assert_equal [@concert], search("_")
    assert_empty search("stage%done")
  end

  test "returns nothing for a blank query" do
    assert_empty search("")
    assert_empty search("   ")
    assert_empty search(nil)
  end

  private
    def search(query)
      Eventdate.search_text(query).order(:startdate).to_a
    end

    def create_eventdate(title, organization, description, locations, startdate)
      event = Event.new(title: title, organization: organization, status: Event::Event_Status_Initial_Request,
                        contactemail: "contact@example.com", contact_name: "Contact", billable: true, rental: false, notes: "")
      eventdate = event.eventdates.first
      eventdate.assign_attributes(description: description, startdate: startdate, enddate: startdate + 3.hours,
                                  calldate: startdate - 1.hour, strikedate: startdate + 3.hours,
                                  notes: "", email_description: "", locations: locations)
      event.save!
      eventdate
    end
end
