Settings.SettingsSyncController = Ember.ArrayController.extend({
  lookupItemController: function(object) {
    var provider = object.get('service.provider');

    if (provider === "dropbox") {
      return provider + "SyncService";
    } else {
      return "syncService";
    }
  },

  actions: {
    openAuthWindow: function(service) {
      window.open(service.get('authURL'), service.get('provider'), 'width=972,height=660,modal=yes,alwaysRaised=yes');
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

