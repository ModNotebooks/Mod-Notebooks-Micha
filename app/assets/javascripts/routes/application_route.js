App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
  model: function() {
    if (this.get('session.isAuthenticated')) {
      return this.store.find('user', 'me');
    }
  },

  setupController: function(controller, currentUser) {
    this.controllerFor('currentUser').set('model', currentUser);
    App.inject('controller', 'currentUser', 'controller:currentUser');
  },

  actions: {
    sessionAuthenticationFailed: function(error) {
      this.controllerFor('login').set('isLoading', false);
      this.controllerFor('login').set('loginErrorMessage', "Invalid username or password");
    },

    sessionAuthenticationSucceeded: function() {
      var _this = this;
      var _super = this._super.bind(this);

      this.controllerFor('login').set('loginErrorMessage');

      this.model().then(function(user) {
        this.setupController(this, user);
        _this.controllerFor('login').set('isLoading', false);
        _super();
      });
    },

    sessionInvalidationSucceeded: function() {
      // Reset the store
      // http://www.kaspertidemann.com/how-to-clear-the-ember-data-store-in-ember-js/
      this.store.init();

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
