App.ApplicationView = Ember.View.extend({
  tagName: 'main',

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
  }.observes('controller.currentPath').on('init')
});
