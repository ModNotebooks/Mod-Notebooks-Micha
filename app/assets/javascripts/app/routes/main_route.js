App.MainRoute = Ember.Route.extend(Core.ResetScrollMixin);

App.MainIndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('notebooks');
  }
});
