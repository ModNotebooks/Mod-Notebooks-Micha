Settings.SyncServiceController = Ember.ObjectController.extend({
  actions: {
    connectionSucceeded: function(data) {
      var model = this.get('content');
      var service = model.get('service');

      service.save().then(function() {
        Ember.Logger.info('Service connected -', service.get('provider'));
      }, function(error) {
        Ember.Logger.warn('Could not connect to service -', service.get('provider'));
        model.set('isEnabled', false);
        service.rollback();
      });
    },

    connectionFailed: function(error) {
      var model = this.get('content');
      var service = model.get('service');

      Ember.Logger.warn('Service failed to authenticate -', error.provider);

      model.set('isEnabled', false);
    },

    disconnect: function() {
      var model    = this.get('content'),
          service  = model.get('service'),
          provider = service.get('provider'),
          store    = this.store;

      var provider = service.get('provider');
      service.destroyRecord().then(function() {
        Ember.Logger.info('Disconnected service -', provider);
        model.set('service', store.createRecord('service', {
          provider: provider
        }));
      }, function(err) {
        Ember.Logger.warn('Could not disconnect service', err);
      });
    },
  },

  toggleConnection: function() {
    var store = this.store,
        model = this.get('model'),
        service = model.get('service');

    if (model.get('isEnabled') && !service.get('isConnected')) {
      this.send('openAuthWindow', service);
    } else if (!model.get('isEnabled') && service.get('isConnected')) {
      this.send('disconnect');
    }
  }.observes('isEnabled')

});
