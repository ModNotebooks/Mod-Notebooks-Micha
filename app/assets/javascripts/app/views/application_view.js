App.ApplicationView = Ember.View.extend({
  tagName: 'main',
  classNameBindings: ['session.isAuthenticated:l-app-main:l-guest-main'],

  layoutName: function() {
    var path = this.get('controller.currentPath');

    switch(path) {
      case "login":
      case "signup":
      case "password_reset":
      case "digitize.index":
      case "digitize.code":
        return "application-guest";
      case "viewer":
      case "viewer.pages":
        return "application-viewer";
      default:
        return "application";
    }
  }.property('controller.currentPath'),

  updateLayout: function() {
    this.rerender();
  }.observes('layoutName'),

  bodyClass: function() {
    var isAuthenticated = this.get('session.isAuthenticated');
    var path = this.get('controller.currentPath') || window.location.pathname;
    var isDigitize = path && path.match(/digitize/i);

    if (isAuthenticated && !isDigitize) {
      Ember.$(document.body)
        .removeClass('dark')
    } else {
      Ember.$(document.body)
        .addClass('dark');
    }
  }.observes('layoutName').on('init')
});
