# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
  function doAsync(url) {
    var http_request = false;

    if (window.XMLHttpRequest) { // Mozilla, Safari, ...
      http_request = new XMLHttpRequest();

      if (http_request.overrideMimeType) {
        http_request.overrideMimeType('text/xml');
      }
    } else if (window.ActiveXObject) { // IE
      try {
        http_request = new ActiveXObject("Msxml2.XMLHTTP");
      } catch (e) {
        try {
          http_request = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e) {}
      }
    }

    if (!http_request) {
      alert('Giving up :( Cannot create an XMLHTTP instance');
      return false;
    }

    http_request.open('GET', url, false);
    http_request.send(null);
  }

  function doAndReload(url) {
    doAsync(url);
    location.reload(true);
  }

  var tid;
  var popped;

  function finishPopupAndReload() {
    if (popped.closed)
    {
      clearInterval(tid);

      location.reload(true);
    }
  }

  function popup(url) {
    window.open(url);
  }

  function popupAndReload(url) {
    popped = window.open(url);

    tid = setInterval('finishPopupAndReload()', 500);
  }

