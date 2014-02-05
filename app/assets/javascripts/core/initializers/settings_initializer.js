Ember.Application.initializer({
  name: 'settings',
  initialize: function(container, application) {

    Ember.Instrumentation.subscribe("app.openSettings", {
      before: function(name, timestamp, payload) {
        container.lookup('route:application').send('openSettings');
      }, after: Ember.K
    });

    Ember.Instrumentation.subscribe("app.closeSettings", {
      before: function(name, timestamp, payload) {
        container.lookup('route:application').send('closeSettings');
      }, after: Ember.K
    });

  }
});
