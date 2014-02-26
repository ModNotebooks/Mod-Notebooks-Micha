App.DigitizeAddressRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, App.DigitizeRouteMixin, {
  previousStep: 'digitize.scan',

  model: function() {
    return this.store.find('address', 'me');
  }
});
