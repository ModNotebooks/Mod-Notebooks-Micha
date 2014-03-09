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
          Ember.run.next(application, application.reset);
        }, after: Ember.K
      });

      application.set('authenticationSubscriber', authenticationSubscriber);
    }

    if (application.name === "main") {
      var logoutSubscriber = application.get('logoutSubscriber');

      if (!Ember.isEmpty(logoutSubscriber)) {
        Ember.Instrumentation.unsubscribe(logoutSubscriber);
      }

      logoutSubscriber = Ember.subscribe('logout', {
        before: function(name, timestamp, payload) {
          container.lookup('route:application').send('invalidateSession');
        }, after: Ember.K
      });
    }
  }
});
