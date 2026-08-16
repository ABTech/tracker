// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
  var eventSelect = $('#timecard_entry_eventdate_id_and_eventpart');
  var timecardSelect = $('#timecard_entry_timecard_id');
  if (!eventSelect.length || !timecardSelect.length) return;

  var allOptions = timecardSelect.find('option').clone();

  function setMultiMode(options) {
    timecardSelect.empty().append(options.clone()).show().prop('disabled', false);
    $('#timecard-single-display').hide();
    $('#timecard_id_single').prop('disabled', true);
    $('#timecard-no-match-message').hide();
  }

  function setSingleMode(option) {
    timecardSelect.hide().prop('disabled', true);
    $('#timecard-single-display').text(option.text()).show();
    $('#timecard_id_single').val(option.val()).prop('disabled', false);
    $('#timecard-no-match-message').hide();
  }

  function setNoMatchMode() {
    timecardSelect.empty().append(allOptions.clone()).show().prop('disabled', false);
    $('#timecard-single-display').hide();
    $('#timecard_id_single').prop('disabled', true);
    $('#timecard-no-match-message').show();
  }

  function updateTimecardField() {
    var startDate = eventSelect.find(':selected').data('startdate');
    if (!startDate) { setMultiMode(allOptions); return; }

    var eventDate = new Date(startDate);
    var matching = allOptions.filter(function () {
      return eventDate >= new Date($(this).data('start')) &&
             eventDate <= new Date($(this).data('end'));
    });

    if (matching.length === 0) {
      setNoMatchMode();
    } else if (matching.length === 1) {
      setSingleMode(matching.first());
    } else {
      setMultiMode(matching);
    }
  }

  eventSelect.change(updateTimecardField);
  updateTimecardField();
});
