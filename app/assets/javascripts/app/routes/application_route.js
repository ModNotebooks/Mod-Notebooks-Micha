App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {

  setupController: function() {
    if (this.get('session.isAuthenticated')) {
      Ember.instrument("app.isAuthenticated", {}, Ember.K);
    }
  },

  actions: {
    sessionAuthenticationFailed: function(error) {
      this.controllerFor('login').set('isLoading', false);
      this.controllerFor('login').set('loginErrorMessage', "Invalid username or password");
    },

    sessionAuthenticationSucceeded: function() {
      this.controllerFor('login').set('isLoading', false);
      this._super();
      Ember.instrument("sessionAuthenticationSucceeded", {}, Ember.K)
    },

    sessionInvalidationSucceeded: function() {
      // TODO: Reset the store
      this._super();
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

    modalChange: function(visible) {
      this.controller.set('modalVisible', visible);
    },

    openModal: function(name) {
      return this.render(name, {
        into: 'application',
        outlet: 'modal'
      });
    },

    closeModal: function() {
      return this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    },

    openSettings: function() {
      this.controller.set('modalVisible', true);
    },

    closeSettings: function() {
      this.controller.set('modalVisible', false);
    },

    toggleSettings: function() {
      if (this.controller.get('modalVisible')) {
        Ember.instrument("closeSettings", {}, Ember.K);
      } else {
        Ember.instrument("openSettings", {}, Ember.K);
      }
    }
  }
});
