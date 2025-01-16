$(function () {
  return $(".toggle-div").click(function () {
    return $("#" + $(this).data("div")).toggle("Blind");
  });
});
