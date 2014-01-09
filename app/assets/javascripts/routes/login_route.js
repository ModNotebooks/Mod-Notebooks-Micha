App.LoginRoute = Ember.Route.extend(App.RequireUnauthenticatedRouteMixin, {
  renderTemplate: function(controller, model) {
    this._super(controller, model);
    this.render('loginHeader', { outlet: 'header' });
  }
});
