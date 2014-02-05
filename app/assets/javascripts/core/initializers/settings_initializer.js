Ember.Application.initializer({
  name: 'settings',
  initialize: function(container, application) {
    Ember.Instrumentation.subscribe("openSettings", {
      before: function(name, timestamp, payload) {
        container.lookup('route:application').send('openSettings');
      }, after: Ember.K
    });

    Ember.Instrumentation.subscribe("closeSettings", {
      before: function(name, timestamp, payload) {
        container.lookup('route:application').send('closeSettings');
      }, after: Ember.K
    });

    Ember.Instrumentation.subscribe('sessionAuthenticationSucceeded', {
      before: function(name, timestamp, payload) {
        if (application.name === "settings") {
          application.reset();
        }
      }, after: Ember.K
    });

    Ember.Instrumentation.subscribe('sessionInvalidationSucceeded', {
      before: function(name, timestamp, payload) {
        if (application.name === "main") {
          container.lookup('route:application').send('invalidateSession');
        }
      }, after: Ember.K
    });
  }
});
