Settings.SyncServiceController = Ember.ObjectController.extend({
  toggleConnection: function() {
    var store = this.store,
        model = this.get('model'),
        service = model.get('service');

    if (model.get('isEnabled') && !service.get('isConnected')) {
      this.send('openAuthWindow', service);
    } else if (!model.get('isEnabled') && service.get('isConnected')) {
      var provider = service.get('provider');
      service.destroyRecord().then(function() {
        model.set('service', store.createRecord('service', {
          provider: provider
        }));
      }, function(err) { console.error(err); });
    }
  }.observes('isEnabled')

});
