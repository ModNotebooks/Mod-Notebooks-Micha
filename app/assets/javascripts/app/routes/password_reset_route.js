App.PasswordResetRoute = Ember.Route.extend(App.RequireUnauthenticatedRouteMixin, {
  renderTemplate: function(controller, model) {
    this._super(controller, model);
    this.render('signupHeader', { outlet: 'header' });
  }
});
