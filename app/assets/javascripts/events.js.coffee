# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("a.delete_field").click ->
    $(this).prev("input[type=hidden]").val("1")
    $(this).closest(".fields").hide()
    
@setUpSuperTicAdd = (parent) ->
  parent.find(".supertic_add_role_button").click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_event_roles", "g")
    whereToAdd = $(this).parents("table").first().children("tbody").children("tr").last()
    toAdd = $(this).prev().children("option:selected").data("role").replace(regexp, new_id)
    whereToAdd.before(toAdd)
    $(".association-" + new_id + " a.delete_field").click ->
      $(this).closest(".fields").remove()
      
@setUpSuperTicEdit = (ed,roles) ->
  ed.find(".start-time-field").children(".day, .month, .year").change ->
    day = parseInt($(this).parent().children(".day").val())
    month = parseInt($(this).parent().children(".month").val())-1
    year = parseInt($(this).parent().children(".year").val())
    dayOfWeek = new Date(year, month, day).getDay()
    if dayOfWeek == 0
      dayOfWeek = 7
    roles.find(".supertic_add_role_select").val(dayOfWeek)
    
@setUpEventDate = (ed) ->
  ed.find(".datetime_select").each ->
    parent = $(this)
    setDateMonths(parent)
    $(this).children(".month, .year").change ->
      setDateMonths(parent)
  ed.find(".copy_start_time").click ->
    starttime = $(this).parents(".event-date-form").find(".start-time-field")
    $(this).parent().each ->
      $(this).children(".month").val(starttime.children(".month").val())
      $(this).children(".year").val(starttime.children(".year").val())
      setDateMonths($(this))
      $(this).children(".day").val(starttime.children(".day").val())
  ed.find(".call-time-field, .strike-time-field").each ->
    parent = $(this)
    if parent.prev().val() == "literal"
      parent.show()
    else
      parent.hide()
    parent.prev().change ->
      if parent.prev().val() == "literal"
        parent.show()
      else
        parent.hide()
  setUpSuperTicEdit(ed, ed.find(".event-form-roles"))

@setUpAddFields = () ->
  $("a.add_field").click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_" + $(this).data("association"), "g")
    
    if $(this).data("association") == "eventdates"
      prev = $(this).parents("#event-form-dates").children(".event-date-form").last()
      $(this).parent().before($(this).data("content").replace(regexp, new_id))
      added = $(this).parents("#event-form-dates").children(".event-date-form").last()
      setDateMonths(added.find(".call-time-field"), prev.find(".call-time-field"))
      setDateMonths(added.find(".start-time-field"), prev.find(".start-time-field"))
      setDateMonths(added.find(".end-time-field"), prev.find(".end-time-field"))
      setDateMonths(added.find(".strike-time-field"), prev.find(".strike-time-field"))
      added.find(".eventdate_locations").val(prev.find(".eventdate_locations").val())
      setUpEventDate(added)
      setUpSuperTicAdd(added)
    else
      $(this).parent().before($(this).data("content").replace(regexp, new_id))
      
    $(".association-" + new_id + " a.delete_field").click ->
      $(this).closest(".fields").remove()
    setUpAddFields()
  $("a.add_field2").click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_" + $(this).data("association"), "g")
    $(this).parent().parent().before($(this).data("content").replace(regexp, new_id))
    $(".association-" + new_id + " a.delete_field").click ->
      $(this).closest(".fields").remove()
    setUpAddFields()
  $("a.add_field").removeClass("add_field")
  $("a.add_field2").removeClass("add_field2")

$ ->
  setUpAddFields()
  $(".event-form-roles").each ->
    setUpSuperTicAdd($(this))
  $(".event-date-form").each ->
    setUpEventDate($(this))
  setUpSuperTicEdit($(".event-date-form").first(), $("fieldset.event-form-roles"))
  

$ ->
  $("a.add_blackout_fields").click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_blackout", "g")
    $(this).parent().before($(this).data("content").replace(regexp, new_id))
    $(this).hide()

$ ->
  $("a.delete_blackout_fields").click ->
    $(this).prev("input[type=hidden]").val("1")
    $("#event_blackout_form").before("Blackout removed.")
    $("#event_blackout_form").hide()

@setDateMonths = (parent, other = null) ->
  if other == null
    year = parseInt(parent.children(".year").children(":selected").val())
    month = parseInt(parent.children(".month").children(":selected").val())
    day = parseInt(parent.children(".day").children(":selected").val())
  else
    year = parseInt(other.children(".year").children(":selected").val())
    month = parseInt(other.children(".month").children(":selected").val())
    day = parseInt(other.children(".day").children(":selected").val())
    parent.children(".year").val(year)
    parent.children(".month").val(month)
  days = new Date(year, month, 0).getDate()
  if days < day
    day = 1
  day_select = parent.children(".day")
  day_select.empty()
  for d in [1..days]
    if d == day
      day_select.append("<option value=\"" + d + "\" selected=\"selected\">" + d + "</option>")
    else
      day_select.append("<option value=\"" + d + "\">" + d + "</option>")

@updateCalendarExportLink = () ->
  param = $("#gencalex_form input[name=gen_param]:checked").val()
  root = $("#gencalex_root").val()
  output = ""
  if param == "range"
    output += "?startdate="
    output += $("#gencalex_startdate_year").val()
    output += "-"
    output += $("#gencalex_startdate_month").val()
    output += "-"
    output += $("#gencalex_startdate_day").val()
    output += "&amp;enddate="
    output += $("#gencalex_enddate_year").val()
    output += "-"
    output += $("#gencalex_enddate_month").val()
    output += "-"
    output += $("#gencalex_enddate_day").val()
  else if param == "matchdate"
    output += "?matchdate="
    output += $("#gencalex_matchdate_year").val()
    output += "-"
    output += $("#gencalex_matchdate_month").val()
    output += "-"
    output += $("#gencalex_matchdate_day").val()
  else if param == "soon"
    output += "?period=soon"
  else if param == "period"
    output += "?period="
    output += $("#gencalex_period").val()
    output += $("#gencalex_period_year_year").val()
  $("#gencalex_ical_result").html("<a href=\"" + root + "calendar/generate.ics" + output + "\">" + root + "calendar/generate.ics" + output + "</a>")
  $("#gencalex_text_result").html("<a href=\"" + root + "calendar/generate.schedule" + output + "\">" + root + "calendar/generate.schedule" + output + "</a>")
      
$ ->
  updateCalendarExportLink()
  $("#gencalex_form input, #gencalex_form select").change ->
    updateCalendarExportLink()

$ ->
  if $("#event_blackout_attributes__destroy").prop("checked")
    $(".event-blackout-fields").show()
  $("#event_blackout_attributes__destroy").change ->
    if $("#event_blackout_attributes__destroy").prop("checked")
      $(".event-blackout-fields").show()
    else
      $(".event-blackout-fields").hide()

$ ->
  if $("#event_org_type").val() == "new"
    $("#event_organization_id").hide()
    $("#event_org_new").show()
  $("#event_org_type").change ->
    if $("#event_org_type").val() == "new"
      $("#event_organization_id").hide()
      $("#event_org_new").show()
    else
      $("#event_org_new").hide()
      $("#event_organization_id").show()
