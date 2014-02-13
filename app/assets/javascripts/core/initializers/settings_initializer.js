Ember.Application.initializer({
  name: 'settings',
  initialize: function(container, application) {
    Ember.subscribe("openSettings", {
      before: function(name, timestamp, payload) {
        container.lookup('route:application').send('openSettings');
      }, after: Ember.K
    });

    Ember.subscribe("closeSettings", {
      before: function(name, timestamp, payload) {
        container.lookup('route:application').send('closeSettings');
      }, after: Ember.K
    });

    if (application.name === "settings") {
      // If we have done this before we need to unsubscribe from it.
      var authenticationSubscriber = application.get('authenticationSubscriber');

      if (!Ember.isEmpty(authenticationSubscriber)) {
        Ember.Instrumentation.unsubscribe(authenticationSubscriber);
      }

      authenticationSubscriber = Ember.subscribe('sessionAuthenticationSucceeded', {
        before: function(name, timestamp, payload) {
          application.reset();
        }, after: Ember.K
      });

      application.set('authenticationSubscriber', authenticationSubscriber);
    }

    if (application.name === "main") {
      var invalidationSubscriber = application.get('invalidationSubscriber');

      if (!Ember.isEmpty(invalidationSubscriber)) {
        Ember.Instrumentation.unsubscribe(invalidationSubscriber);
      }

      invalidationSubscriber = Ember.subscribe('sessionInvalidationSucceeded', {
        before: function(name, timestamp, payload) {
          container.lookup('route:application').send('invalidateSession');
        }, after: Ember.K
      });
    }
  }
});
