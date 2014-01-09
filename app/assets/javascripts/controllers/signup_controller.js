App.SignupController = Ember.ObjectController.extend(App.LoginMixin, {
  actions: {
    submit: function() {
      var _this = this;

      var identification = this.get('model.email');
      var password       = this.get('model.password');
      this.get('model').save()
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
            });
          }, function(xhr, status, error) {
            _this.transitionTo(Ember.SimpleAuth.loginRoute);
          });
        }, function() {
          // TODO: ERRORS
          console.log('FAIL!');
        });
    }
  }

});
