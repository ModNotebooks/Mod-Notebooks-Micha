App.TouchViewerRoute = Ember.Route.extend({
  model: function(params) {
    return this.store.find('page', { notebook_id: params.notebook_id });
  }
});
