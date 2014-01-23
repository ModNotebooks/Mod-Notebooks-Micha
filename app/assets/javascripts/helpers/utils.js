App.utils = (function() {

  var Utils = {};

  Utils.transitionEnd = (function() {
    var transEndEventNames = {
        'WebkitTransition' : 'webkitTransitionEnd',// Saf 6, Android Browser
        'MozTransition'    : 'transitionend',      // only for FF < 15
        'transition'       : 'transitionend'       // IE10, Opera, Chrome, FF 15+, Saf 7+
    };
    return transEndEventNames[ Modernizr.prefixed('transition') ];
  }());

  return Utils;

}());
