App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {

  setupController: function() {
    if (this.get('session.isAuthenticated')) {
      Ember.instrument("app.isAuthenticated", {}, Ember.K);
    }
  },

  actions: {
    sessionAuthenticationFailed: function(error) {
      this.controllerFor('login.index').set('isLoading', false);
      this.controllerFor('login.index').set('loginErrorMessage', "Invalid username or password");
    },

    sessionAuthenticationSucceeded: function() {
      this._super();
      Ember.instrument("sessionAuthenticationSucceeded", {}, Ember.K)
      this.controllerFor('login.index').set('isLoading', false);
      this.controllerFor('login.index').set('loginErrorMessage', null);
    },

    sessionInvalidationSucceeded: function() {
      // TODO: Reset the store
      this._super();
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

     // This is not getting called for some reason so lets do it ourselves
    // https://github.com/simplabs/ember-simple-auth/blob/master/packages/ember-simple-auth/lib/mixins/application_route_mixin.js#L160
    error: function(reason) {
      var _this = this;
      if (reason.status === 401) {
        this.get('session').invalidate().then(function() {
          _this.transitionTo(Ember.SimpleAuth.routeAfterInvalidation);
        });
      }
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
