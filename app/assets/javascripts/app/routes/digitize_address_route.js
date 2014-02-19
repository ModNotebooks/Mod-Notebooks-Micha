App.DigitizeAddressRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {

  beforeModel: function(transition) {
    var previousStepCompleted = this.controllerFor('digitize.scan').get('completed');
    if (!previousStepCompleted) {
      transition.abort();
      this.transitionTo('digitize.scan');
    }
  }

});
