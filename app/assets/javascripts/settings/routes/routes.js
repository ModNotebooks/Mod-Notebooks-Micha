Settings.ApplicationRoute = Ember.Route.extend({
  setupController: function(controller) {
    this._super(controller);

    Ember.Instrumentation.subscribe("app.openSettings", {
      before: function(name, timestamp, payload) {
        controller.set('isVisible', true);
      }, after: Ember.K
    });

    Ember.Instrumentation.subscribe("app.closeSettings", {
      before: function(name, timestamp, payload) {
        controller.set('isVisible', false);
      }, after: Ember.K
    });
  },

  actions: {
    close: function() {
      this.controllerFor('application').set('isVisible', false);
    }
  }
});

Settings.IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('settings.account');
  }
});

Settings.SettingsAccountRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('user', 'me');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
  }
});

Settings.SettingsAddressRoute = Ember.Route.extend({
  model: function() {
    return this.store.find('address', 'me');
  }
});

Settings.SettingsSyncRoute = Ember.Route.extend({});
