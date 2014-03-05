App.NotebookRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    var store = this.store;
    return store.find('notebook', params.notebook_id);
  },

  afterModel: function(model, transition) {
    return model.get('pages');
  },

  renderTemplate: function(controller, model) {
    this._super(controller, model);
    this.render('notebookSide', {
      outlet: 'side'
    });
  },

  setupController: function(controller, model) {
    controller.set('model', model);
    controller.set('pages', model.get('pages'));
  }
});
