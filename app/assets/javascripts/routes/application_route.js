App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
  actions: {
    loginFailed: function(errorMessage) {
      this.controllerFor('login').set('loginErrorMessage', "Error logging in");
    }
  }
});
