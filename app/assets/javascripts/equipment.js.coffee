# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("#equipment-list").masonry({
    "itemSelector": ".equipment-category",
    "columnWidth": ".equipment-category",
    "percentPosition": true
  })
  $("#equipment-calendar").fullCalendar({
    events: '/equipment/' + $("#equipment-calendar").data("id") + '.json',
    left:   'title',
    center: '',
    right:  'today prev,next'
  })
  $("#equipment_category").change ->
    $("#equipment_subcategory").html($("#equipment_category option:selected").data("subcategories"))
  $(".edit_equipment_category").click ->
    $("#equipment_category").replaceWith($("#equipment_category").data("text"))
    if $("#equipment_subcategory").data("did") != true
      $("#equipment_subcategory").replaceWith($("#equipment_subcategory").data("text"))
    $(".edit_equipment_category").remove()
    $(".edit_equipment_subcategory").remove()
  $(".edit_equipment_subcategory").click ->
    $("#equipment_subcategory").replaceWith($("#equipment_subcategory").data("text"))
    $(".edit_equipment_subcategory").remove()