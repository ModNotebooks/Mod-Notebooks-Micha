App.DigitizeIndexController = Ember.ObjectController.extend({
  needs: ['digitize'],

  authenticator: Ember.SimpleAuth.Authenticators.OAuth2,

  loginIsLoading: false,
  loginButtonText: "Login",
  loginIdentification: null,
  loginPassword: null,

  signupIsLoading: false,
  signupButtonText: "Sign up",

  completed: false,

  actions: {
    advance: function() {
      var _this = this;
      this.canAdvance().then(function() {
        _this.set('loginError', null);
        _this.set('completed', true);
        _this.transitionToRoute('digitize.code');
      });
    },

    login: function() {
      var _this = this;
      var data = this.getProperties('loginIdentification', 'loginPassword');

      if (!Ember.isEmpty(data.loginIdentification) && !Ember.isEmpty(data.loginPassword)) {
        _this.authenticate(data.loginIdentification, data.loginPassword)
          .then(function() {
            _this.send('advance');
            _this.set('loginIsLoading', false);
          }, function(error) {
            _this.set('loginIsLoading', false);
            _this.set("loginErrorMessage", "Invalid email or password");
          });
      } else {
        Ember.run.later(this, function() {
          this.set('loginIsLoading', false);
        });
      }
    },

    signup: function() {
      var _this = this,
          model = this.get('model'),
          identification = model.get('email'),
          password       = model.get('password');

      model.save()
        .then(function() {
          _this.authenticate(identification, password)
            .then(function() {
              _this.send('advance');
              _this.set('signupIsLoading', false);
            }, function(error) {
              _this.set('signupIsLoading', false);
            });
        }, function(error) {
          _this.set('signupIsLoading', false);
        });
    }
  },

  authenticate: function(identification, password) {
    var _this = this;
    var authenticator = _this.get('authenticator').create();
    var options = {
      identification: identification,
      password: password
    };

    return new Ember.RSVP.Promise(function(resolve, reject) {
      authenticator.authenticate(options).then(function(content) {
        _this.get('session').setup('ember-simple-auth:authenticators:oauth2', content, false);
        Ember.instrument("sessionAuthenticationSucceeded", {}, Ember.K);
        resolve(options);
      }, function(error) {
        reject(error);
      });
    });
  },

  canAdvance: function() {
    var _this = this;
    var code = this.get('code');

    return new Ember.RSVP.Promise(function(resolve, reject) {
      if (_this.get('session.isAuthenticated')) {
        resolve();
      } else {
        reject();
      }
    });
  },
});
