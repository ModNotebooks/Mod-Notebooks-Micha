Settings.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
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

Settings.SettingsSyncRoute = Ember.Route.extend({
  model: function() {
    var store = this.store;

    return new Ember.RSVP.Promise(function(resolve, reject) {
      store.find('service').then(function(models) {

        var connections = ['Dropbox', 'Evernote', 'OneNote'].map(function(name) {
          var provider = name.toLowerCase(),
              service = models.findBy('provider', provider) || store.createRecord('service', {
                provider: provider
              });

          return Core.ServiceConnection.create({
            name: name,
            service: service,
            isEnabled: service.get('isConnected')
          });
        });

        resolve(connections);

      }, function(err) { reject(err); });
    });

  }
});
