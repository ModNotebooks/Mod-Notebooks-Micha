App.NotebookRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    var store = this.store;
    return store.find('notebook', params.notebook_id);
  },

  afterModel: function(model, transition) {
    return model.get('pages');
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('pages', model.get('pages'));
  }
});
