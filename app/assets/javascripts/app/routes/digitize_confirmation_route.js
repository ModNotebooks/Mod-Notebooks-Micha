App.DigitizeConfirmationRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {

  beforeModel: function(transition) {
    var previousStepCompleted = this.controllerFor('digitize.address').get('completed');
    if (!previousStepCompleted) {
      transition.abort();
      this.transitionTo('digitize.address');
    }
  }

});
