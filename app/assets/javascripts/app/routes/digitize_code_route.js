App.DigitizeCodeRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, App.DigitizeRouteMixin, {
  previousStep: 'digitize.index',

  model: function() {
    return this.store.find('notebook_setting');
  },

  setupController: function(controller, model) {
    controller.set('settings', model);
  }
});
