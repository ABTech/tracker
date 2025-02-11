// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
window.setupAjaxLoader = function () {
  return $.ajaxSetup({
    beforeSend: function () {
      return $("#loader").show();
    },
    complete: function () {
      return $("#loader").hide();
    },
    success: function () {},
  });
};

window.hideOptionsMenu = function (menu) {
  menu.removeClass("visible");
  return menu.parent().children(".email-options-link").removeClass("invisible");
};

$(function () {
  $(".hidden-header-toggle").click(function () {
    if ($(this).data("clicked") === "no") {
      $(this).data("clicked", "yes");
      $(this).text("Hide Extra Headers");
      $(this).parent().parent().find(".hidden-header").css("display", "block");
    } else {
      $(this).data("clicked", "no");
      $(this).text("Show Hidden Headers");
      $(this).parent().parent().find(".hidden-header").css("display", "none");
    }
    return window.hideOptionsMenu($(this).parent());
  });
  $(".email-contents-quote-mode").click(function () {
    var contents;
    contents = $(this).parent().parent().parent().find(".the-content");
    contents.data("quote-mode", $(this).data("quote-mode"));
    contents.html(
      window.simpleFormat(contents.data($(this).data("quote-mode"))),
    );
    $(this)
      .parent()
      .children(".email-contents-quote-mode")
      .removeClass("active");
    $(this).addClass("active");
    return window.hideOptionsMenu($(this).parent());
  });
  $(".email-options-link").click(function () {
    $(this).addClass("invisible");
    return $(this).parent().children(".email-options").addClass("visible");
  });
  $(".close-options").click(function () {
    return window.hideOptionsMenu($(this).parent());
  });
  $(".email-unread-toggle").click(function () {
    var link;
    if ($(this).data("clicked") === "no") {
      $(this).text("Mark Read");
      $(this).data("clicked", "yes");
      window.setupAjaxLoader();
      $.ajax({
        url: $(this).data("url"),
        type: "put",
        data: "email[unread]=1",
      });
    } else {
      link = $(this);
      window.setupAjaxLoader();
      $.ajax({
        url: $(this).data("url"),
        type: "put",
        data: "email[unread]=0",
        success: function () {
          link.text("Mark Unread");
          return link.data("clicked", "no");
        },
      });
    }
    return window.hideOptionsMenu($(this).parent());
  });
  $(".email-reply-link").click(function () {
    window.setupAjaxLoader();
    return $.ajax({
      url: window.reply_email_path,
      data: "id=" + $(this).data("email-id"),
      dataType: "script",
      success: "success",
    });
  });
  $(".email-new-event-link").click(function () {
    window.setupAjaxLoader();
    return $.ajax({
      url: window.new_event_email_path,
      data: "id=" + $(this).data("email-id"),
      dataType: "script",
      success: "success",
    });
  });
  $(".email-existing-event-link").click(function () {
    window.setupAjaxLoader();
    return $.ajax({
      url: window.existing_event_email_path,
      data: "id=" + $(this).data("email-id"),
      dataType: "script",
      success: "success",
    });
  });
  return $(".email-unfile-link").click(function () {
    window.setupAjaxLoader();
    return $.ajax({
      url: $(this).data("url"),
      type: "put",
      data: "email[event_id]=nil",
      success: function () {
        return window.location.reload(true);
      },
    });
  });
});
