$ ->
  $('.toggle-div').click ->
    $("#" + $(this).data('div')).toggle("Blind")
