App.LoginController = Ember.Controller.extend(Ember.SimpleAuth.LoginControllerMixin, App.LoginMixin, {
  client_id: App.OAUTH_ID,
  client_secret: App.OAUTH_SECRET
});
