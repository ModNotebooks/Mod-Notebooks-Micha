//= require modernizr/modernizr
//= require modernizr/feature-detects/css-filters
//= require_self

(function() {
  Modernizr.addTest('firefox', function () {
    return !!navigator.userAgent.match(/firefox/i);
  });
}());
