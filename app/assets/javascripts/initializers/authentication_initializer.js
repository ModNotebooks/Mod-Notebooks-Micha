Ember.Application.initializer({
  name: 'authentication',
  initialize: function(container, application) {
    Ember.SimpleAuth.setup(container, application, {
      crossOriginWhitelist: ['http://api.lvh.me:3000'],
      serverTokenEndpoint: 'http://api.lvh.me:3000/oauth/token'
    });
  }
});