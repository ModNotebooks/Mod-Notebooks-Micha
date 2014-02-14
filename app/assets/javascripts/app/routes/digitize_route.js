App.DigitizeRoute = Ember.Route.extend({
  model: function() {
    return new Ember.RSVP.Promise(function(resolve, reject) {
      resolve(Core.DigitizeWizard.create({}));
    });
  }
});
