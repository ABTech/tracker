// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function () {
  $("#equipment-profile-list").masonry({
    itemSelector: ".equipment-profile-category",
    columnWidth: ".equipment-profile-category",
    percentPosition: true,
  });
  $("#equipment-profile-calendar").fullCalendar({
    events:
      "/equipment_profile/" +
      $("#equipment-profile-calendar").data("id") +
      ".json",
    left: "title",
    center: "",
    right: "today prev,next",
  });
  $("#equipment_profile_category").change(function () {
    return $("#equipment_profile_subcategory").html(
      $("#equipment_profile_category option:selected").data("subcategories"),
    );
  });
  $(".edit_equipment_profile_category").click(function () {
    $("#equipment_profile_category").replaceWith(
      $("#equipment_profile_category").data("text"),
    );
    if ($("#equipment_profile_subcategory").data("did") !== true) {
      $("#equipment_profile_subcategory").replaceWith(
        $("#equipment_profile_subcategory").data("text"),
      );
    }
    $(".edit_equipment_profile_category").remove();
    return $(".edit_equipment_profile_subcategory").remove();
  });
  return $(".edit_equipment_profile_subcategory").click(function () {
    $("#equipment_profile_subcategory").replaceWith(
      $("#equipment_profile_subcategory").data("text"),
    );
    return $(".edit_equipment_profile_subcategory").remove();
  });
});
