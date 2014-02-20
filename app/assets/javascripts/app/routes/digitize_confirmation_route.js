App.DigitizeConfirmationRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, App.DigitizeRouteMixin, {
  previousStep: 'digitize.address'
});
