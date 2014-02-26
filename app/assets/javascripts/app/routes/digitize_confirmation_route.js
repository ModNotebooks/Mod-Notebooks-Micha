App.DigitizeConfirmationRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, App.DigitizeRouteMixin, {
  previousStep: 'digitize.address',

  model: function() {
    return this.store.createRecord('notebook');
  }
});
