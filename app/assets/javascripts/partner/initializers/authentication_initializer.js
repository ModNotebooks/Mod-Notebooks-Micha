Ember.Application.initializer({
  name: 'authentication',
  initialize: function(container, application) {
    Ember.SimpleAuth.Authenticators.OAuth2.reopen({
      serverTokenEndpoint: window.ENV.AUTH_ENDPOINT + '/oauth/token'
    });

    Ember.SimpleAuth.setup(container, application);
  }
});
