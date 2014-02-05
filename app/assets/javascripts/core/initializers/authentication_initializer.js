Ember.Application.initializer({
  name: 'authentication',
  initialize: function(container, application) {
    Ember.SimpleAuth.Authenticators.OAuth2.reopen({
      serverTokenEndpoint: window.ENV.API_ENDPOINT + '/oauth/token',

      makeRequest: function(data) {
        data.client_id     = window.ENV.OAUTH_ID;
        data.client_secret = window.ENV.OAUTH_SECRET;
        return this._super(data);
      }
    });

    Ember.SimpleAuth.setup(application, {
      crossOriginWhitelist: [window.ENV.API_ENDPOINT]
    });
  }
});