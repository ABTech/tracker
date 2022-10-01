# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.simpleFormat = (str) ->
  str = str.replace(/\r\n?/, "\n")
  str = $.trim(str)
  if str.length > 0
    str = str.replace(/\n\n+/g, '</p><p>')
    str = str.replace(/\n/g, '<br />')
    str = '<p>' + str + '</p>'
  return str

window.setUpDeleteFields = () ->
  $("a.delete_field.undestroyable").click ->
    $(this).prev("input[type=hidden]").val("1")
    $(this).closest(".fields").hide()
  $("a.delete_field.destroyable").click ->
    $(this).closest(".fields").remove()
    
window.setUpSuperTicAdd = (parent) ->
  parent.find(".supertic_add_role_button").click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_event_roles", "g")
    whereToAdd = $(this).parents("table").first().children("tbody").children("tr").last()
    toAdd = $(this).prev().children("option:selected").data("role").replace(regexp, new_id)
    whereToAdd.before(toAdd)
    $(".association-" + new_id + " a.delete_field").click ->
      $(this).closest(".fields").remove()
      
window.setUpSuperTicEdit = (ed,roles) ->
  ed.find(".start-time-field").children(".day, .month, .year").change ->
    day = parseInt($(this).parent().children(".day").val())
    month = parseInt($(this).parent().children(".month").val())-1
    year = parseInt($(this).parent().children(".year").val())
    dayOfWeek = new Date(year, month, day).getDay()
    if dayOfWeek == 0
      dayOfWeek = 7
    roles.find(".supertic_add_role_select").val(dayOfWeek)
    
window.setUpEventDate = (ed) ->
  ed.find(".datetime_select").each ->
    parent = $(this)
    window.setDateMonths(parent)
    $(this).children(".month, .year").change ->
      window.setDateMonths(parent)
  ed.find(".copy_start_time").click ->
    starttime = $(this).parents(".event-date-form").find(".start-time-field")
    $(this).parent().each ->
      $(this).children(".month").val(starttime.children(".month").val())
      $(this).children(".year").val(starttime.children(".year").val())
      window.setDateMonths($(this))
      $(this).children(".day").val(starttime.children(".day").val())
    $(this).siblings(".field_with_errors").each ->
      $(this).children(".month").val(starttime.children(".month").val())
      $(this).children(".year").val(starttime.children(".year").val())
      window.setDateMonths($(this))
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
  window.setUpSuperTicEdit(ed, ed.find(".event-form-roles"))
  ed.find(".eventdate_big_select").chosen({width: "95%"})

window.setUpAddFields = () ->
  $("a.add_field").click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_" + $(this).data("association"), "g")
    
    if $(this).data("association") == "eventdates"
      prev = $(this).parents("#event-form-dates").children(".event-date-form").last()
      $(this).parent().before($(this).data("content").replace(regexp, new_id))
      added = $(this).parents("#event-form-dates").children(".event-date-form").last()
      if prev.length > 0
        window.setDateMonths(added.find(".call-time-field"), prev.find(".call-time-field"))
        window.setDateMonths(added.find(".start-time-field"), prev.find(".start-time-field"))
        window.setDateMonths(added.find(".end-time-field"), prev.find(".end-time-field"))
        window.setDateMonths(added.find(".strike-time-field"), prev.find(".strike-time-field"))
      added.find(".eventdate_locations").val(prev.find(".eventdate_locations").val())
      window.setUpEventDate(added)
      window.setUpSuperTicAdd(added)
    else
      $(this).parent().before($(this).data("content").replace(regexp, new_id))
      
    $(".association-" + new_id + " a.delete_field").click ->
      $(this).closest(".fields").remove()
    window.setUpAddFields()
  $("a.add_field2").click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_" + $(this).data("association"), "g")
    $(this).parent().parent().before($(this).data("content").replace(regexp, new_id))
    $(".association-" + new_id + " a.delete_field").click ->
      $(this).closest(".fields").remove()
    window.setUpAddFields()
  $("a.add_field").removeClass("add_field")
  $("a.add_field2").removeClass("add_field2")

window.setDateMonths = (parent, other = null) ->
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

window.updateCalendarExportLink = () ->
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
  if $("#gencalex_form input[name=gen_hidecompleted]:checked").val()
    output += "&hidecompleted"
  $("#gencalex_ical_result").html("<a href=\"" + root + "calendar/generate.ics" + output + "\">" + root + "calendar/generate.ics" + output + "</a>")
  $("#gencalex_text_result").html("<a href=\"" + root + "calendar/generate.schedule" + output + "\">" + root + "calendar/generate.schedule" + output + "</a>")
      
$ ->
  window.updateCalendarExportLink()
  $("#gencalex_form input, #gencalex_form select").change ->
    window.updateCalendarExportLink()

$ ->
  $("#event-emails h5").click ->
    email = $(this).parent().children(".email")
    if $(this).data("visible") == "yes"
      $(this).data("visible", "no")
      $(this).children(".arrow").html("&#9654;")
    else
      $(this).data("visible", "yes")
      $(this).children(".arrow").html("&#9660;")
    email.toggle("blind")

window.setupForms = () ->
  window.setUpAddFields()
  window.setUpDeleteFields()
  $(".event-form-roles").each ->
    window.setUpSuperTicAdd($(this))
  $(".event-date-form").each ->
    window.setUpEventDate($(this))
  window.setUpSuperTicEdit($(".event-date-form").first(), $("fieldset.event-form-roles"))
  $(".eventdate_big_select").chosen({width: "95%"})
  if $("#event_blackout_attributes__destroy").prop("checked")
    $(".event-blackout-fields").show()
  $("#event_blackout_attributes__destroy").change ->
    if $("#event_blackout_attributes__destroy").prop("checked")
      $(".event-blackout-fields").show()
    else
      $(".event-blackout-fields").hide()
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

$ ->
  window.setupForms()

$ ->
  $("#search.search_empty").focus ->
    $(this).removeClass("search_empty")
    $(this).addClass("search_full")
  $("#search.search_full").blur ->
    $(this).removeClass("search_full")
    $(this).addClass("search_empty")
