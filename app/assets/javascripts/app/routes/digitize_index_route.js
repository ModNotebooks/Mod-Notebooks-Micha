App.DigitizeIndexRoute = Ember.Route.extend({

  beforeModel: function() {
    if (this.get('session.isAuthenticated')) {
      this.transitionTo('digitize.code');
    }
  }

});
