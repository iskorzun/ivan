(function() {
  'use strict';
  var includeLinkCss;
  window.OnBind = function(el, ev, callback) {
    if (el.addEventListener) {
      el.addEventListener(ev, callback, false);
    } else if (el.attachEvent) {
      el.attachEvent('on' + ev, callback);
    }
  };
  includeLinkCss = function(href) {
    var stylesheet;
    stylesheet = document.createElement('link');
    stylesheet.href = href;
    stylesheet.rel = 'stylesheet';
    stylesheet.type = 'text/css';
    document.getElementsByTagName('head')[0].appendChild(stylesheet);
  };
  return window.includeCss = function(arrLink) {
    var i, len, linkCss;
    if (Array.isArray(arrLink)) {
      for (i = 0, len = arrLink.length; i < len; i++) {
        linkCss = arrLink[i];
        includeLinkCss(linkCss);
      }
    } else {
      includeLinkCss(arrLink);
    }
  };
})();
