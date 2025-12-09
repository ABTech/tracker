// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
window.simpleFormat = function (str) {
  str = str.replace(/\r\n?/, "\n");
  str = $.trim(str);
  if (str.length > 0) {
    str = str.replace(/\n\n+/g, "</p><p>");
    str = str.replace(/\n/g, "<br />");
    str = "<p>" + str + "</p>";
  }
  return str;
};

window.setUpDeleteFields = function () {
  $("a.delete_field.undestroyable").click(function () {
    $(this).prev("input[type=hidden]").val("1");
    return $(this).closest(".fields").hide();
  });
  return $("a.delete_field.destroyable").click(function () {
    return $(this).closest(".fields").remove();
  });
};

window.setUpSuperTicAdd = function (parent) {
  return parent.find(".supertic_add_role_button").click(function () {
    var new_id, regexp, toAdd, whereToAdd;
    new_id = new Date().getTime();
    regexp = new RegExp("new_event_roles", "g");
    whereToAdd = $(this)
      .parents("table")
      .first()
      .children("tbody")
      .children("tr")
      .last();
    toAdd = $(this)
      .prev()
      .children("option:selected")
      .data("role")
      .replace(regexp, new_id);
    whereToAdd.before(toAdd);
    return $(".association-" + new_id + " a.delete_field").click(function () {
      return $(this).closest(".fields").remove();
    });
  });
};

window.setUpSuperTicEdit = function (ed, roles) {
  return ed
    .find(".start-time-field")
    .children(".day, .month, .year")
    .change(function () {
      var day, dayOfWeek, month, year;
      day = parseInt($(this).parent().children(".day").val());
      month = parseInt($(this).parent().children(".month").val()) - 1;
      year = parseInt($(this).parent().children(".year").val());
      dayOfWeek = new Date(year, month, day).getDay();
      if (dayOfWeek === 0) {
        dayOfWeek = 7;
      }
      return roles.find(".supertic_add_role_select").val(dayOfWeek);
    });
};

window.setUpEventDate = function (ed) {
  ed.find(".datetime_select").each(function () {
    var parent;
    parent = $(this);
    window.setDateMonths(parent);
    return $(this)
      .children(".month, .year")
      .change(function () {
        return window.setDateMonths(parent);
      });
  });
  ed.find(".copy_start_time").click(function () {
    var starttime;
    starttime = $(this).parents(".event-date-form").find(".start-time-field");
    $(this)
      .parent()
      .each(function () {
        $(this).children(".month").val(starttime.children(".month").val());
        $(this).children(".year").val(starttime.children(".year").val());
        window.setDateMonths($(this));
        return $(this).children(".day").val(starttime.children(".day").val());
      });
    return $(this)
      .siblings(".field_with_errors")
      .each(function () {
        $(this).children(".month").val(starttime.children(".month").val());
        $(this).children(".year").val(starttime.children(".year").val());
        window.setDateMonths($(this));
        return $(this).children(".day").val(starttime.children(".day").val());
      });
  });
  ed.find(".call-time-field, .strike-time-field").each(function () {
    var parent;
    parent = $(this);
    if (parent.prev().val() === "literal") {
      parent.show();
    } else {
      parent.hide();
    }
    return parent.prev().change(function () {
      if (parent.prev().val() === "literal") {
        return parent.show();
      } else {
        return parent.hide();
      }
    });
  });
  window.setUpSuperTicEdit(ed, ed.find(".event-form-roles"));
  return ed.find(".eventdate_big_select").chosen({
    width: "95%",
  });
};

window.setUpAddFields = function () {
  $("a.add_field").click(function () {
    var added, new_id, prev, regexp;
    new_id = new Date().getTime();
    regexp = new RegExp("new_" + $(this).data("association"), "g");
    if ($(this).data("association") === "eventdates") {
      prev = $(this)
        .parents("#event-form-dates")
        .children(".event-date-form")
        .last();
      $(this).parent().before($(this).data("content").replace(regexp, new_id));
      added = $(this)
        .parents("#event-form-dates")
        .children(".event-date-form")
        .last();
      if (prev.length > 0) {
        window.setDateMonths(
          added.find(".call-time-field"),
          prev.find(".call-time-field"),
        );
        window.setDateMonths(
          added.find(".start-time-field"),
          prev.find(".start-time-field"),
        );
        window.setDateMonths(
          added.find(".end-time-field"),
          prev.find(".end-time-field"),
        );
        window.setDateMonths(
          added.find(".strike-time-field"),
          prev.find(".strike-time-field"),
        );
      }
      added
        .find(".eventdate_locations")
        .val(prev.find(".eventdate_locations").val());
      window.setUpEventDate(added);
      window.setUpSuperTicAdd(added);
    } else {
      $(this).parent().before($(this).data("content").replace(regexp, new_id));
    }
    $(".association-" + new_id + " a.delete_field").click(function () {
      return $(this).closest(".fields").remove();
    });
    return window.setUpAddFields();
  });
  $("a.add_field2").click(function () {
    var new_id, regexp;
    new_id = new Date().getTime();
    regexp = new RegExp("new_" + $(this).data("association"), "g");
    $(this)
      .parent()
      .parent()
      .before($(this).data("content").replace(regexp, new_id));
    $(".association-" + new_id + " a.delete_field").click(function () {
      return $(this).closest(".fields").remove();
    });
    return window.setUpAddFields();
  });
  $("a.add_field").removeClass("add_field");
  return $("a.add_field2").removeClass("add_field2");
};

window.setDateMonths = function (parent, other = null) {
  var d, day, day_select, days, i, month, ref, results, year;
  if (other === null) {
    year = parseInt(parent.children(".year").children(":selected").val());
    month = parseInt(parent.children(".month").children(":selected").val());
    day = parseInt(parent.children(".day").children(":selected").val());
  } else {
    year = parseInt(other.children(".year").children(":selected").val());
    month = parseInt(other.children(".month").children(":selected").val());
    day = parseInt(other.children(".day").children(":selected").val());
    parent.children(".year").val(year);
    parent.children(".month").val(month);
  }
  days = new Date(year, month, 0).getDate();
  if (days < day) {
    day = 1;
  }
  day_select = parent.children(".day");
  day_select.empty();
  results = [];
  for (
    d = i = 1, ref = days;
    1 <= ref ? i <= ref : i >= ref;
    d = 1 <= ref ? ++i : --i
  ) {
    if (d === day) {
      results.push(
        day_select.append(
          '<option value="' + d + '" selected="selected">' + d + "</option>",
        ),
      );
    } else {
      results.push(
        day_select.append('<option value="' + d + '">' + d + "</option>"),
      );
    }
  }
  return results;
};

window.updateCalendarExportLink = function () {
  var output, param, root;
  param = $("#gencalex_form input[name=gen_param]:checked").val();
  root = $("#gencalex_root").val();
  output = "";
  if (param === "range") {
    output += "?startdate=";
    output += $("#gencalex_startdate_year").val();
    output += "-";
    output += $("#gencalex_startdate_month").val();
    output += "-";
    output += $("#gencalex_startdate_day").val();
    output += "&amp;enddate=";
    output += $("#gencalex_enddate_year").val();
    output += "-";
    output += $("#gencalex_enddate_month").val();
    output += "-";
    output += $("#gencalex_enddate_day").val();
  } else if (param === "matchdate") {
    output += "?matchdate=";
    output += $("#gencalex_matchdate_year").val();
    output += "-";
    output += $("#gencalex_matchdate_month").val();
    output += "-";
    output += $("#gencalex_matchdate_day").val();
  } else if (param === "soon") {
    output += "?period=soon";
  } else if (param === "period") {
    output += "?period=";
    output += $("#gencalex_period").val();
    output += $("#gencalex_period_year_year").val();
  }
  if ($("#gencalex_form input[name=gen_hidecompleted]:checked").val()) {
    output += "&hidecompleted";
  }
  $("#gencalex_ical_result").html(
    '<a href="' +
      root +
      "calendar/generate.ics" +
      output +
      '">' +
      root +
      "calendar/generate.ics" +
      output +
      "</a>",
  );
  return $("#gencalex_text_result").html(
    '<a href="' +
      root +
      "calendar/generate.schedule" +
      output +
      '">' +
      root +
      "calendar/generate.schedule" +
      output +
      "</a>",
  );
};

$(function () {
  window.updateCalendarExportLink();
  return $("#gencalex_form input, #gencalex_form select").change(function () {
    return window.updateCalendarExportLink();
  });
});

$(function () {
  return $("#event-emails h5").click(function () {
    var email;
    email = $(this).parent().children(".email");
    if ($(this).data("visible") === "yes") {
      $(this).data("visible", "no");
      $(this).children(".arrow").html("&#9654;");
    } else {
      $(this).data("visible", "yes");
      $(this).children(".arrow").html("&#9660;");
    }
    return email.toggle("blind");
  });
});

window.setupForms = function () {
  window.setUpAddFields();
  window.setUpDeleteFields();
  $(".event-form-roles").each(function () {
    return window.setUpSuperTicAdd($(this));
  });
  $(".event-date-form").each(function () {
    return window.setUpEventDate($(this));
  });
  window.setUpSuperTicEdit(
    $(".event-date-form").first(),
    $("fieldset.event-form-roles"),
  );
  $(".eventdate_big_select").chosen({
    width: "95%",
  });
  if ($("#event_blackout_attributes__destroy").prop("checked")) {
    $(".event-blackout-fields").show();
  }
  $("#event_blackout_attributes__destroy").change(function () {
    if ($("#event_blackout_attributes__destroy").prop("checked")) {
      return $(".event-blackout-fields").show();
    } else {
      return $(".event-blackout-fields").hide();
    }
  });
  if ($("#event_org_type").val() === "new") {
    $("#event_organization_id").hide();
    $("#event_org_new").show();
  }
  return $("#event_org_type").change(function () {
    if ($("#event_org_type").val() === "new") {
      $("#event_organization_id").hide();
      return $("#event_org_new").show();
    } else {
      $("#event_org_new").hide();
      return $("#event_organization_id").show();
    }
  });
};

$(function () {
  return window.setupForms();
});

$(function () {
  $("#search.search_empty").focus(function () {
    $(this).removeClass("search_empty");
    return $(this).addClass("search_full");
  });
  return $("#search.search_full").blur(function () {
    $(this).removeClass("search_full");
    return $(this).addClass("search_empty");
  });
});
