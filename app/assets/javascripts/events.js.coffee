# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("a.delete_field").click ->
    $(this).prev("input[type=hidden]").val("1")
    $(this).closest(".fields").hide()

$ ->
  $("a.add_field").click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_" + $(this).data("association"), "g")
    $(this).parent().before($(this).data("content").replace(regexp, new_id))
    $(".association-" + new_id + " a.delete_field").click ->
      $(this).closest(".fields").remove()

$ ->
  $("a.add_field2").click ->
    new_id = new Date().getTime()
    regexp = new RegExp("new_" + $(this).data("association"), "g")
    $(this).parent().parent().before($(this).data("content").replace(regexp, new_id))
    $(".association-" + new_id + " a.delete_field").click ->
      $(this).closest(".fields").remove()

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
