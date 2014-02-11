Core.utils = (function() {

  var Utils = {};

  Utils.transitionEnd = (function() {
    var transEndEventNames = {
        'WebkitTransition' : 'webkitTransitionEnd',// Saf 6, Android Browser
        'MozTransition'    : 'transitionend',      // only for FF < 15
        'transition'       : 'transitionend'       // IE10, Opera, Chrome, FF 15+, Saf 7+
    };
    return transEndEventNames[ Modernizr.prefixed('transition') ];
  }());

  Utils.popup = function(url, name, options) {
    options = $.extend({
      location:   "no",
      resizable:  "no",
      scrollbars: "no",
      status:     "no",
      width:      1024,
      height:     768
    }, options);

    if (!options.top && !options.left) {
      options.left = ($(window).width() / 2) - (options.width / 2) + window.screenX;
      options.top  = ($(window).height() / 2) - (options.height / 2) + window.screenY;
    }

    options = Ember.keys(options).map(function(key, index) {
      return key + "=" + options[key];
    }).join(',');

    return window.open(url, name, options);
  };

  Utils.humanize = function(str) {
    return str.replace(/_id$/, '').
      replace(/_/g, ' ').
      replace(/^\w/g, function(s){
        return s.toUpperCase();
      });
  };

  String.prototype.humanize = function() {
    return Utils.humanize(this);
  };

  return Utils;

}());
