// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function () {
  return $(".members-to-edit").multiSelect({
    selectableOptgroup: true,
    cssClass: "members-to-edit-css",
  });
});
