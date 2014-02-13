App.LoginRoute = Ember.Route.extend(Core.RequireUnauthenticatedRouteMixin, {
  renderTemplate: function(controller, model) {
    this._super(controller, model);
    this.render('loginHeader', { outlet: 'header' });
  }
});
