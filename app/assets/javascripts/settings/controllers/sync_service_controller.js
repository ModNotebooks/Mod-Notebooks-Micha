Settings.SyncServiceController = Ember.ObjectController.extend({
  toggleConnection: function() {
    var model = this.get('model'),
        service = model.get('service');

    if (model.get('isEnabled') && !service.get('isConnected')) {
      this.send('openAuthWindow', service);
    } else {
      var provider = service.get('provider');
      service.destroyRecord()
    }

  }.observes('isEnabled')

});
