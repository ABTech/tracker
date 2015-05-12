# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".hidden-header-toggle").click ->
    if $(this).data("clicked") == "no"
      $(this).data("clicked", "yes")
      $(this).text("Hide Extra Headers")
      $(this).parent().find(".hidden-header").css("display", "block")
    else
      $(this).data("clicked", "no")
      $(this).text("Show Hidden Headers")
      $(this).parent().find(".hidden-header").css("display", "none")
  $(".email-contents-quote-mode a").click ->
    contents = $(this).parent().parent().parent()
    contents.data("quote-mode", $(this).data("quote-mode"))
    contents.children(".the-content").html(contents.data($(this).data("quote-mode")))
    $(this).parent().parent().find("a").removeClass("active")
    $(this).addClass("active")
