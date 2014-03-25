App.ViewerRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {
  model: function(params) {
    return this.store.find('notebook', params.notebook_id);
  },

  afterModel: function(model, transition) {

  },

  setupController: function(controller, model) {
    controller.set('notebook', model);
  }
});

App.ViewerPagesRoute = Ember.Route.extend(Ember.SimpleAuth.AuthenticatedRouteMixin, {

  model: function(params) {
    var notebook = this.modelFor('viewer');

    return new Ember.RSVP.Promise(function(resolve, reject) {
      notebook.get('pages').then(function(pages) {
        resolve([
          pages.findBy('pageNumber', parseInt(params.left_page_number, 10)),
          pages.findBy('pageNumber', parseInt(params.right_page_number, 10)),
        ]);
      }, function(err) {
        reject(err);
      })
    });
  },

  setupController: function(controller, model) {

  },

  serialize: function(model) {
    var page = model.get('pageNumber');

    if (page === 1) {
      return { left_page_number: 0, right_page_number: page }
    } else {
      return { left_page_number: page, right_page_number: page + 1 }
    }
  }
});
