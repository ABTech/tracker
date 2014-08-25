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

@setDateMonths = (parent) ->
  year = parseInt(parent.children(".year").children(":selected").val())
  month = parseInt(parent.children(".month").children(":selected").val())
  day = parseInt(parent.children(".day").children(":selected").val())
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

$ ->
  $(".datetime_select").each ->
    parent = $(this)
    setDateMonths(parent)
    $(this).children(".month, .year").change ->
      setDateMonths(parent)
