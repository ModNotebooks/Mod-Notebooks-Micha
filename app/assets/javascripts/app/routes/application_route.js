App.ApplicationRoute = Ember.Route.extend(Ember.SimpleAuth.ApplicationRouteMixin, {
  actions: {
    sessionAuthenticationFailed: function(error) {
      this.controllerFor('login').set('isLoading', false);
      this.controllerFor('login').set('loginErrorMessage', "Invalid username or password");
    },

    sessionAuthenticationSucceeded: function() {
      this.controllerFor('login').set('isLoading', false);
      this._super();
    },

    sessionInvalidationSucceeded: function() {
      // Reset the store
      // http://www.kaspertidemann.com/how-to-clear-the-ember-data-store-in-ember-js/
      this.store.init();
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

    openSettings: function() {
      Ember.Instrumentation.instrument("app.openSettings");
      this.controller.set('settingsVisible', true);
    },

    closeSettings: function() {
      Ember.Instrumentation.instrument("app.closeSettings");
      this.controller.set('settingsVisible', false);
    },

    toggleSettings: function() {
      // Such a shitty hack!
      if (this.controller.get('settingsVisible')) {
        this.send('closeSettings');
      } else {
        this.send('openSettings');
      }
    }
  }
});
