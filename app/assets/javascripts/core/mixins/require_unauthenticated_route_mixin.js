Core.RequireUnauthenticatedRouteMixin = Ember.Mixin.create({
  beforeModel: function(transition) {
    if (this.get('session.isAuthenticated')) {
      transition.abort();
      this.transitionTo('index');
    }
  },
});
