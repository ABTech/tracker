# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("a.delete_field").click ->
    $(this).prev("input[type=hidden]").val("1")
    $(this).closest(".fields").hide()

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
  $(".datetime_select").each ->
    parent = $(this)
    setDateMonths(parent)
    $(this).children(".month, .year").change ->
      setDateMonths(parent)
  $(".copy_start_time").click ->
    starttime = $(this).parents(".event-date-form").find(".start-time-field")
    $(this).parent().each ->
      $(this).children(".month").val(starttime.children(".month").val())
      $(this).children(".year").val(starttime.children(".year").val())
      setDateMonths($(this))
      $(this).children(".day").val(starttime.children(".day").val())

$ ->
  setUpAddFields()

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
