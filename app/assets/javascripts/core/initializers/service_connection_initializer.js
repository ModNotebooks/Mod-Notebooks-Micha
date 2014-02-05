Ember.Application.initializer({
  name: 'service_connections',
  initialize: function(container, application) {
    Core.ServiceConnector.setup(container, application);
  }
});
