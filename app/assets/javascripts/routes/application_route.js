App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
  actions: {
    loginFailed: function(errorMessage) {
      this.controllerFor('login').set('isLoading', false);
      this.controllerFor('login').set('loginErrorMessage', "Invalid username or password");
    },

    loginSucceeded: function() {
      this.controllerFor('login').set('loginErrorMessage');
      this.controllerFor('login').set('isLoading', false);
      this._super();
    },

    openModal: function(modalName, model) {
      this.controllerFor(modalName).set('model', model);

      return this.render(modalName, {
        into: 'application',
        outlet: 'modal'
      });
    },

    closeModal: function() {
      return this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    }
  }
});
