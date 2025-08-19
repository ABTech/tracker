// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function () {
  return $("#timecard-dropdown").change(function () {
    return (window.location = $(this).children(":selected").val());
  });
});
