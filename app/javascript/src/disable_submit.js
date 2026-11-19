// Disable submit buttons that have data-disable-with (added by Rails to
// submit_tag and f.submit) while their form submits, so slow requests like
// sending an invoice email can't be submitted twice.
//
// TODO: Remove this file when migrating to Turbo with Drive enabled, since
// Turbo disables the submitter during form submission on its own. Use
// data-turbo-submits-with where custom text is needed, and consider setting
// config.action_view.automatically_disable_submit_tag = false.
document.addEventListener("submit", function (event) {
  var form = event.target;

  // Wait until the submission has started, because disabled buttons are left
  // out of the submitted form data. Skip submissions that were cancelled, such
  // as by a data-tracker-confirm prompt.
  setTimeout(function () {
    if (event.defaultPrevented) {
      return;
    }

    Array.prototype.forEach.call(form.elements, function (element) {
      var disableWith = element.getAttribute("data-disable-with");
      if (disableWith === null || element.disabled) {
        return;
      }

      element.trackerEnableWith = element.tagName === "INPUT" ? element.value : element.innerHTML;
      if (element.tagName === "INPUT") {
        element.value = disableWith;
      } else {
        element.innerHTML = disableWith;
      }
      element.disabled = true;
    });
  }, 0);
});

// Re-enable the buttons when the browser restores this page from its
// back/forward cache, so they aren't stuck disabled after going back.
window.addEventListener("pageshow", function (event) {
  if (!event.persisted) {
    return;
  }

  document.querySelectorAll("[data-disable-with]").forEach(function (element) {
    if (element.trackerEnableWith === undefined) {
      return;
    }

    if (element.tagName === "INPUT") {
      element.value = element.trackerEnableWith;
    } else {
      element.innerHTML = element.trackerEnableWith;
    }
    element.disabled = false;
    delete element.trackerEnableWith;
  });
});
