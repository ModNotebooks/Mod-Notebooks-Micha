App.NotebooksRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function() {
    return this.store.find('notebook');
  },

  renderTemplate: function() {
    this.render();

    this.render('notebooks', {
      into: 'application',
      outlet: 'content'
    });
  },

  setupController: function(controller, notebooks) {
    controller.set('content', notebooks);
  }
});
