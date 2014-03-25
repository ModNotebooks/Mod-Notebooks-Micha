App.NotebooksRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, Core.ResetScrollMixin, {
  model: function() {
    return this.store.find('notebook');
  },

  setupController: function(controller, notebooks) {
    controller.set('content', notebooks);
  }
});
