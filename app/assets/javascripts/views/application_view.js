App.ApplicationView = Ember.View.extend({
  tagName: 'main',
  classNameBindings: ['session.isAuthenticated:l-app-main:l-guest-main'],

  layoutName: function() {
    var path = this.get('controller.currentPath');

    switch(path) {
      case "login":
      case "signup":
      case "reset":
        return "guest";
      default:
        return "application";
    }

  }.property('controller.currentPath'),

  updateLayout: function() {
    this.rerender();
  }.observes('layoutName'),

  isAuthenticated: function() {
    if (this.get('session.isAuthenticated')) {
      Ember.$(document.body)
        .removeClass('asleep')
        .addClass('awake');
    } else {
      Ember.$(document.body)
        .removeClass('awake')
        .addClass('asleep');
    }
  }.observes('session.isAuthenticated').on('init')
});
