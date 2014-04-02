App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
  actions: {
    sessionAuthenticationFailed: function(error) {
      this.controllerFor('login').set('loginErrorMessage', "Invalid email or password");
    },

    sessionAuthenticationSucceeded: function() {
      this._super();
      this.controllerFor('login').set('loginErrorMessage', null);
    },
  }
});
