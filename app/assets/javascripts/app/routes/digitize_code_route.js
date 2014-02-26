App.DigitizeCodeRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, App.DigitizeRouteMixin, {
  previousStep: 'digitize.index'
});
