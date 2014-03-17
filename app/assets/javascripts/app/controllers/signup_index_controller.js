App.SignupIndexController = Ember.ObjectController.extend({
  buttonText: "Sign Up",
  isLoading: false,

  authenticatorFactory: 'ember-simple-auth:authenticators:oauth2',

  actions: {
    submit: function() {
      var _this = this;

      var model = this.get('model'),
          identification = model.get('email'),
          password       = model.get('password');

      model.save()
        .then(function() {
          var options = {
            identification: identification,
            password: password
          };

          _this.get('session').authenticate(_this.get('authenticatorFactory'), options).then(function() {
            _this.set('isLoading', false);
            _this.send('sessionAuthenticationSucceeded');
          }, function(error) {
            _this.set('isLoading', false);
            _this.transitionTo(Ember.SimpleAuth.authenticationRoute);
          });
        }, function() {
          _this.set('isLoading', false);
        });
    }
  }

});
