App.MainRoute = Ember.Route.extend();

App.MainIndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('notebooks');
  }
});
