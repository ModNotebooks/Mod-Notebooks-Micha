App.TouchViewerRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('page', { notebook_id: params.notebook_id });
  }
});

App.TouchViewerPageRoute = Ember.Route.extend({
  model: function(params) {
    return params;
  },

  setupController: function(controller, model) {
    this.controllerFor('touchViewer').set('currentSlide', parseInt(model.index, 10) - 1);
  }
});
