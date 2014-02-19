App.DigitizeScanRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {

  beforeModel: function(transition) {
    var previousStepCompleted = this.controllerFor('digitize.code').get('completed');
    if (!previousStepCompleted) {
      transition.abort();
      this.transitionTo('digitize.code');
    }
  }

});
