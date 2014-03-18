App.DemoRoute = Ember.Route.extend({
  redirect: function() {
    this.controllerFor('login.index').set('identification', 'demo@modnotebooks.com');
    this.controllerFor('login.index').set('password', 'password');
    this.transitionTo('login');
  }
});
