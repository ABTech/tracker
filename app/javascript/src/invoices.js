// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function () {
  $("#invoice_payment_type").change(function () {
    if ($(this).val() === "Oracle") {
      return $("#oracleString").show("Blind");
    } else {
      return $("#oracleString").hide("Blind");
    }
  });
  return $("#invoice_status").change(function () {
    if ($(this).val() === "Loan Agreement") {
      return $("#loan-agreement-notice").show("Blind");
    } else {
      return $("#loan-agreement-notice").hide("Blind");
    }
  });
});

window.chooseLinePreset = function (id) {
  var selected;
  if ($("#invoice-line-preset-" + id).val() !== "") {
    selected = $("#invoice-line-preset-" + id + " option:selected").first();
    if (selected.data('notes')) {
      showNotes(id);
    }
    $("#invoice_invoice_lines_attributes_" + id + "_category").val(
      selected.data("category"),
    );
    $("#invoice_invoice_lines_attributes_" + id + "_memo").val(
      selected.data("memo"),
    );
    $("#invoice_invoice_lines_attributes_" + id + "_notes").val(
      selected.data('notes')
    );
    $("#invoice_invoice_lines_attributes_" + id + "_quantity").val("1");
    return $("#invoice_invoice_lines_attributes_" + id + "_price").val(
      selected.data("price"),
    );
  }
};

window.toggleNotes = function (id) {
  var link, note;
  note = $("#notes" + id);
  link = $("#notesToggle" + id);
  if (note.css("display") === "none") {
    note.css("display", "block");
    return link.html("^");
  } else {
    note.css("display", "none");
    return link.html("V");
  }
};

window.showNotes = function(id) {
  var link, note;
  note = $("#notes" + id);
  link = $("#notesToggle" + id);
  if (note.css("display") === "none") {
    note.css("display", "block");
    return link.html("^");
  }
};

window.indexList = function () {
  return $("input.index").each(function (i) {
    return $(this).val(i);
  });
};

$(function () {
  return window.indexList();
});

$(function () {
  return $("#sortable").sortable({
    stop: window.indexList,
    items: "tr.fields",
  });
});

$(function () {
  return $("a.replace_field").click(function () {
    var new_id, regexp;
    new_id = new Date().getTime();
    regexp = new RegExp("new_" + $(this).data("association"), "g");
    return $("#" + $(this).data("repid")).html(
      $(this).data("content").replace(regexp, new_id),
    );
  });
});
