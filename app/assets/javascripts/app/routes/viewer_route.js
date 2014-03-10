App.ViewerRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    return this.store.find('page', { notebook_id: params.notebook_id });
  },

  renderTemplate: function(controller, model) {
    this._super(controller, model);
    this.render('viewerSide', {
      outlet: 'side'
    });
  }
});

App.ViewerPagesRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    var pages = this.modelFor('viewer');

    return [
      pages.findBy('index', parseInt(params.left_page_index, 10)) || Ember.Object.create({ index: Number.MIN_VALUE, blank: true }),
      pages.findBy('index', parseInt(params.right_page_index, 10)) || Ember.Object.create({ index: Number.MAX_VALUE, blank: true })
    ].compact();
  },

  setupController: function(controller, model) {
    if (!Ember.isArray(model)) {
      var params = this.serialize(model);
      this._super(controller, this.model(params));
    } else {
      this._super(controller, model);
    }
  },

  serialize: function(model) {
    return { left_page_index: model.get('leftPageIndex'), right_page_index: model.get('rightPageIndex') };
  }
});
