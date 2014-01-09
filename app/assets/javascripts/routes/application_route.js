App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
  actions: {
    loginFailed: function(errorMessage) {
      this.controllerFor('login').set('isLoading', false);
      this.controllerFor('login').set('loginErrorMessage', "Error logging in");
    },

    loginSucceeded: function() {
      this.controllerFor('login').set('loginErrorMessage');
      this.controllerFor('login').set('isLoading', false);
      this._super();
    }
  }
});
