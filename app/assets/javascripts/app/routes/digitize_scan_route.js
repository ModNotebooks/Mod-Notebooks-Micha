App.DigitizeScanRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin,  App.DigitizeRouteMixin, {
  previousStep: 'digitize.code'
});
