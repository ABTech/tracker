// Ask for confirmation before submitting any form with data-tracker-confirm.
//
// TODO: When migrating to Turbo with Drive enabled, consider replacing this
// with Turbo's data-turbo-confirm (set on the form, as button_to's form option
// does today). Check the behavior matches first, since Turbo only prompts for
// forms it submits.
document.addEventListener("submit", function (event) {
  var message = event.target.getAttribute("data-tracker-confirm");
  if (message && !window.confirm(message)) {
    event.preventDefault();
  }
});
