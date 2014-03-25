App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {

  setupController: function() {
    if (this.get('session.isAuthenticated')) {
      Ember.instrument("app.isAuthenticated", {}, Ember.K);
    }
  },

  actions: {
    sessionAuthenticationFailed: function(error) {
      this.controllerFor('login.index').set('isLoading', false);
      this.controllerFor('login.index').set('loginErrorMessage', "Invalid email or password");
    },

    sessionAuthenticationSucceeded: function() {
      this._super();
      Ember.instrument("sessionAuthenticationSucceeded", {}, Ember.K);
      this.controllerFor('login.index').set('isLoading', false);
      this.controllerFor('login.index').set('loginErrorMessage', null);
    },

    modalChange: function(visible) {
      this.controllerFor('main').set('modalVisible', visible);
    },

    openModal: function(name) {
      return this.render(name, {
        into: 'main',
        outlet: 'modal'
      });
    },

    closeModal: function() {
      return this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'main'
      });
    },

    openSettings: function() {
      this.controllerFor('main').set('modalVisible', true);
      this.controllerFor('main').set('settingsVisible', true);
    },

    closeSettings: function() {
      this.controllerFor('main').set('modalVisible', false);
      this.controllerFor('main').set('settingsVisible', false);
    },

    toggleSettings: function() {
      if (this.controllerFor('main').get('modalVisible')) {
        Ember.instrument("closeSettings", {}, Ember.K);
      } else {
        Ember.instrument("openSettings", {}, Ember.K);
      }
    }
  }
});
