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
    var _this = this;

    return new Ember.RSVP.Promise(function(resolve, reject) {
      _this.store.find('service').then(function(services) {

        var defaultServices = ['dropbox', 'evernote', 'onenote'];

        services = defaultServices.map(function(item, index, enumerable) {
          var existingService = services.findBy('provider', item);
          if (existingService)
            return existingService;

          return _this.store.createRecord('service', {
            provider: item
          });
        });

        resolve(services);
      }, function(error) { reject(error); });
    });
  },

  setupController: function(controller, models) {
    console.log('models', models);
  }
});
