Settings.SettingsSyncController = Ember.ArrayController.extend({
  providers: ['dropbox', 'evernote', 'live_connect'],

  lookupItemController: function(object) {
    var provider = object.get('service.provider');

    if (this.get('providers').contains(provider)) {
      return provider + "SyncService";
    } else {
      return "syncService";
    }
  },

  actions: {
    openAuthWindow: function(service) {
      var authWindow = Core.utils.popup(service.get('authURL'), service.get('provider'));
    },

    connectionSucceeded: function(data) {
      var provider = data.provider,
          serviceController = this.findBy('content.service.provider', provider);

      serviceController.send('connectionSucceeded', data);
    },

    connectionFailed: function(error) {
      var provider = error.provider,
          serviceController = this.findBy('content.service.provider', provider);

      serviceController.send('connectionFailed', error);
    }
  }
});

