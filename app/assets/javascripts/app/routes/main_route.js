App.MainRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {});

App.MainIndexRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  redirect: function() {
    this.transitionTo('notebooks');
  }
});
