Settings.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
  setupController: function(controller) {
    this._super(controller);
  },

  actions: {
    sessionInvalidationSucceeded: function() {
      Ember.instrument("closeSettings", {}, Ember.K);
      var _super = this._super.bind(this);

      Ember.run.later(function() {
        Ember.instrument("sessionInvalidationSucceeded", {}, Ember.K)
        _super();
      }, 750);
    },

    openSettings: function() {
      this.controllerFor('application').set('isVisible', true);
    },

    closeSettings: function() {
      this.controllerFor('application').set('isVisible', false);
    }
  }
});

Settings.IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('settings.account');
  }
});

Settings.SettingsAccountRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function() {
    return this.store.find('user', 'me');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
  }
});

Settings.SettingsAddressRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function() {
    return this.store.find('address', 'me');
  }
});

Settings.SettingsSyncRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function() {
    var store = this.store;

    return new Ember.RSVP.Promise(function(resolve, reject) {
      var providers = [
        ['Dropbox', 'dropbox'],
        ['Evernote', 'evernote'],
        ['OneNote', 'live_connect']];

      store.find('service').then(function(models) {

        var connections = providers.map(function(provider) {
          var service = models.findBy('provider', provider[1]) || store.createRecord('service', {
                provider: provider[1]
              });

          return Core.ServiceConnection.create({
            name: provider[0],
            service: service,
            isEnabled: service.get('isConnected')
          });
        });

        resolve(connections);

      }, function(err) { reject(err); });
    });
  },

  actions: {
    connectionSucceeded: function(data) {
      this.controllerFor('settings.sync').send('connectionSucceeded', data);
    },

    connectionFailed: function(error) {
      this.controllerFor('settings.sync').send('connectionFailed', error);
    }
  }
});
