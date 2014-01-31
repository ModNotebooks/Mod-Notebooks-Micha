App.SignupController = Ember.ObjectController.extend({
  buttonText: "Sign Up",
  isLoading: false,

  authenticator: Ember.SimpleAuth.Authenticators.OAuth2,

  actions: {
    submit: function() {
      var _this = this;

      var model = this.get('model'),
          identification = model.get('email'),
          password       = model.get('password');

      model.save()
        .then(function() {

          options = {
            identification: identification,
            password: password
          };

          _this.get('session').authenticate(_this.get('authenticator').create(), options).then(function() {
            _this.set('isLoading', false);
            _this.send('sessionAuthenticationSucceeded');
          }, function(error) {
            _this.transitionTo(Ember.SimpleAuth.authenticationRoute);
          });
        }, function() {
          // model.send("becameValid");
          _this.set('isLoading', false);
        });
    }
  }

});
