App.DigitizeAddressRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, App.DigitizeRouteMixin, {

  previousStep: 'digitize.scan'

});
