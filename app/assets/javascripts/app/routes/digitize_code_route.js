App.DigitizeCodeRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {

  beforeModel: function(transition) {
    var previousStepCompleted = this.controllerFor('digitize.index').get('completed');
    if (!previousStepCompleted) {
      transition.abort();
      this.transitionTo('digitize.index');
    }
  }

});
