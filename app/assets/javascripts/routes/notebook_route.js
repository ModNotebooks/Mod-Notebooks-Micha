App.NotebookRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    return this.store.find('notebook', params.notebook_id);
  },

  renderTemplate: function() {
    this.render('notebook', {
      into: 'application',
      outlet: 'content'
    })
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('pages', model.get('pages'));
  }
});
