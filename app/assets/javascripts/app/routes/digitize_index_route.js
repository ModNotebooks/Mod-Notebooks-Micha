App.DigitizeIndexRoute = Ember.Route.extend({

  afterModel: function(model, transition) {
    if (this.get('session.isAuthenticated')) {
      this.controllerFor('digitize.index').set('completed', true);
      this.transitionTo('digitize.code');
    }
  }

});
