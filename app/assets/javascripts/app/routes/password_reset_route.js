App.PasswordResetRoute = Ember.Route.extend(Core.RequireUnauthenticatedRouteMixin, {
  renderTemplate: function(controller, model) {
    this._super(controller, model);
    this.render('signupHeader', { outlet: 'header' });
  }
});
