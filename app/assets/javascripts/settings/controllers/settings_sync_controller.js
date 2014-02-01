App.SettingsSyncController = Ember.ArrayController.extend({
  lookupItemController: function(object) {
    // Implement
  },

  actions: {
    toggleConnect: function(service) {
      if (service.get('disabled')) {
        this.send('connect', service);
      } else {
        this.send('disconnect', service);
      }
    },

    connect: function(service) {
      window.open(service.get('authURL'));
    },

    disconnect: function(service) {
      console.log('disconnecting service');
    }
  }
});

