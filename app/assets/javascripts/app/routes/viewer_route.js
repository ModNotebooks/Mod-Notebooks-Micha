App.ViewerRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    return this.store.find('notebook', params.notebook_id);
  },

  setupController: function(controller, model) {
    controller.set('notebook', model);
  }
});

App.ViewerPagesRouter = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  // model: function()
});
