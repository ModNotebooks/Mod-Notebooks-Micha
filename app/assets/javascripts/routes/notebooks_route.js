App.NotebooksRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function() {
    return this.store.find('notebook');
  },

  setupController: function(controller, notebooks) {
    controller.set('content', notebooks);
  }
});
