App.SignupRoute = Ember.Route.extend(App.RequireUnauthenticatedRouteMixin, {
  model: function() {
    return this.store.createRecord('user')
  },

  renderTemplate: function(controller, model) {
    this._super(controller, model);
    this.render('signupHeader', { outlet: 'header' });
  }
});
