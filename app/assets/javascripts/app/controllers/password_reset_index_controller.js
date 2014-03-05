App.PasswordResetIndexController = Ember.Controller.extend({
  actions: {
    resetPassword: function() {
      var _this = this;
      this.set('isLoading', true);

      Ember.$.ajax({
        url: window.ENV.API_ENDPOINT + '/passwords/reset.json',
        data: { email: this.get('emailAddress') },
        dataType: 'json',
        method: 'POST'
      }).then(function() {
        _this.set('formErrorMessage');
        _this.set('isLoading', false);
      }, function(error) {
        _this.set('formErrorMessage', "Email not found");
        _this.set('isLoading', false);
      });
    }
  }
});
