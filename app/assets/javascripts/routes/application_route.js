App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
  actions: {
    loginFailed: function(errorMessage) {
      console.log(this.controllerFor('login'));
      this.controllerFor('login').set('loginErrorMessage', errorMessage);
    }
  }
});
