App.LoginRoute = Ember.Route.extend(Core.RequireUnauthenticatedRouteMixin, {});

App.LoginIndexRoute = Ember.Route.extend(Core.RequireUnauthenticatedRouteMixin, {
  renderTemplate: function(controller, model) {
    this._super(controller, model);
    this.render('loginHeader', { outlet: 'header' });
  }
});

App.SignupRoute = Ember.Route.extend(Core.RequireUnauthenticatedRouteMixin, {});

App.SignupIndexRoute = Ember.Route.extend(Core.RequireUnauthenticatedRouteMixin, {
  model: function() {
    return this.store.createRecord('user')
  },

  renderTemplate: function(controller, model) {
    this._super(controller, model);
    this.render('signupHeader', { outlet: 'header' });
  }
});
