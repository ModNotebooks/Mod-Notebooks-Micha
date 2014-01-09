App.ApplicationView = Ember.View.extend({

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
  }.observes('layoutName')

});
