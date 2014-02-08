# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit_paymeth').click ->
    $("#paymeth_field_" + $(this).data('repid')).html($(this).data("content"))

$ ->
  $('.edit_notes').click ->
    $("#notes_field_" + $(this).data('repid')).html($(this).data("content"))
