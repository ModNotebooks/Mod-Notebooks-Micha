App.LoginController = Ember.Controller.extend(Ember.SimpleAuth.LoginControllerMixin, {
  client_id: window.ENV.OAUTH_ID,
  client_secret: window.ENV.OAUTH_SECRET,
  buttonText: "Login",
  isLoading: false,

  actions: {
    authenticate: function() {
      var data = this.getProperties('identification', 'password');

      if (!Ember.isEmpty(data.identification) && !Ember.isEmpty(data.password)) {
        this._super();
      } else {
        Ember.run.later(this, function() {
          this.set('isLoading', false);
        });
      }
    }
  }
});
