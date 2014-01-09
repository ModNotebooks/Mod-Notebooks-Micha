App.LoginController = Ember.Controller.extend(Ember.SimpleAuth.LoginControllerMixin, App.LoginMixin, {
  client_id: App.OAUTH_ID,
  client_secret: App.OAUTH_SECRET,
  buttonText: "Login",
  isLoading: false,

  actions: {
    login: function() {
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
