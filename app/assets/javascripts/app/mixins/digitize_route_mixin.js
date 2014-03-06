App.DigitizeRouteMixin = Ember.Mixin.create({
  previousStep: '',

  beforeModel: function(transition) {
    var step = this.get('previousStep');

    if (!Ember.isEmpty(step)) {
      var previousStepCompleted = this.controllerFor(step).get('completed');
      if (!previousStepCompleted) {
        transition.abort();
        this.transitionTo(step);
      }
    }
  }
});
