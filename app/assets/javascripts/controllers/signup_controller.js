App.SignupController = Ember.ObjectController.extend(App.LoginMixin, {
  buttonText: "Sign Up",
  isLoading: false,

  actions: {
    submit: function() {
      var _this = this;

      var model = this.get('model')
      var identification = model.get('email');
      var password       = model.get('password');

      model.save()
        .then(function() {
          // This is shitty to do right here
          // but lets log them in
          var requestOptions = _this.tokenRequestOptions(
            identification, password,
            App.OAUTH_ID, App.OAUTH_SECRET
          );

          Ember.$.ajax(Ember.SimpleAuth.serverTokenEndpoint, requestOptions).then(function(response) {
            Ember.run(function() {
              _this.get('session').setup(response);
              _this.send('loginSucceeded');
              _this.set('isLoading', false);
            });
          }, function(xhr, status, error) {
            _this.transitionTo(Ember.SimpleAuth.loginRoute);
          });
        }, function() {
          // TODO: ERRORS
          console.log('FAIL!');
          model.send("becameValid");
          _this.set('isLoading', false);
        });
    }
  }

});
