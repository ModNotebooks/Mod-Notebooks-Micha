Ember.Application.initializer({
  name: 'authentication',
  initialize: function(container, application) {
    var loc = window.location;

    Ember.SimpleAuth.Authenticators.OAuth2.reopen({
      serverTokenEndpoint: window.ENV.AUTH_ENDPOINT + '/oauth/token'
    });

    Ember.SimpleAuth.setup(container, application, {
      authenticationRoute: 'login',
      routeAfterAuthentication: 'main',
      routeAfterInvalidation: 'login',
      crossOriginWhitelist: [loc.protocol + window.ENV.API_ENDPOINT]
    });
  }
});
